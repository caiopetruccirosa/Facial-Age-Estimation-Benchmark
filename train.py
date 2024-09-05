import os
import git
import yaml
import sys
import torch
import random
import numpy as np
import torch.optim as optim
from lib.training import *
from lib.utils import *
from lib.model import initialize_model
from lib.data_loaders import MyYamlLoader, NormalizedImages, get_data_transform
import argparse
import wandb
from datetime import datetime

from dotenv import load_dotenv
from pytz import timezone

# fix random seeds for reproducibility
SEED = 123
torch.manual_seed(SEED)
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
np.random.seed(SEED)
random.seed(SEED)

# added to solve the problem with too many open files when using >0 workers
# https://github.com/pytorch/pytorch/issues/11201
import torch.multiprocessing
torch.multiprocessing.set_sharing_strategy('file_system')  

print("PyTorch Version: ", torch.__version__)
print("Torchvision Version: ", torchvision.__version__)

if __name__ == '__main__':

    # Get input arguments
    parser = argparse.ArgumentParser(description="Train multi-head CNN image predictor.",\
                 usage="train config.yaml split [--dry]")
    parser.add_argument("config")
    parser.add_argument("split",type=int)
    parser.add_argument("--dry",action="store_true")
    parser.add_argument("--wandb-disabled",action="store_true")
    parser.add_argument("--wandb-offline",action="store_true")
    args = parser.parse_args()

    # Load config
    if not os.path.exists(args.config):
        sys.exit(f"Config file {args.config} does not exist.")
    with open( args.config,'r') as stream:
        config = yaml.load(stream, Loader=MyYamlLoader )
    print(config)
    
    # Log outputs to a directory specified by git tag if available
    try:
        import git
        repo = git.Repo(search_parent_directories=True)
        tagmap = {}
        for t in repo.tags:
            tagmap[str(t.commit)] = str(t.name)
            
        current_commit = str(repo.head.object.hexsha)

        print(f"Commit {current_commit}")
        if current_commit in tagmap.keys():
            git_versioning = f"/{tagmap[current_commit]}"
            print(f"Found a tag {git_versioning}")
        else:
            print(f"No tag found for commit {current_commit}")
            git_versioning = ''

    except:
        git_versioning = ''
        
    print(f"Git versioning subdir: {git_versioning}")
    
    # Input/output folders and files
    config_name = os.path.basename( args.config ).split('.')[0]
    data_dir = f"{config['data']['data_dir']}{config_name}/"
    protocol_file = f"{data_dir}data_split{args.split}.csv"
    output_dir = config["data"]["output_dir"] + config_name + git_versioning + f"/split{args.split}/"
    model_fname = os.path.join( output_dir, "model" )
    evaluation_fname = os.path.join( output_dir, "evaluation.pt" )
    
    # Output folder
    create_dir(output_dir)
    
    # Log experiment start time and if possible, current commit
    with open(os.path.join(output_dir, "version.log"), "a") as handle:
        handle.write("\n"+"-"*50)
        handle.write(f"\nStarting the experiment at {datetime.now()}")
        try:
            import git
            handle.write("\n"+str(git.Git().log(-1)))
        except:
            print("Could not run `git log`. Are you in a git repository and have gitpython installed?")
            handle.write(f"\nFailed to run git log. Run `pip install gitpython`.")    

    # Init WANDB
    mode = "online" 
    if args.wandb_disabled:
        mode = "disabled"
    if args.wandb_offline:
        model = "offline"
    
    # Load WANDB_API_KEY as environment variable
    load_dotenv()

    tz_sao_paulo = timezone('America/Sao_Paulo')

    wandb_project = "Facial-Age-Estimation-Benchmark"
    wandb_name = config_name + f"({args.split}) " + datetime.now(tz=tz_sao_paulo).strftime("%m/%d/%Y, %H:%M:%S")
    wandb.init( project=wandb_project, config=dict( yaml= args.config ), name = wandb_name, mode=mode )

    # Detect if we have a GPU available
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    print(f"running on: {device}")

    # Create loss matrix for each task
    # The loss is used as the objective to be minimized during the model selection.
    # The first item in the "heads/metric" is used as the loss.
    num_heads = len( config['heads'] )
    label_tags = []
    loss_matrix = {}
    for head in config['heads']:
        label_tags.append( head['tag'] )
        loss_matrix[head['tag']] = get_loss_matrix( len( head['labels'] ), head['metric'][0] ).to(device)

    # Initialize the model
    model = initialize_model( config )
    model = model.to( device )

    # Data augmentation and normalization for training and validation
    data_transforms = {
        'trn': get_data_transform( "trn", config ),
        'val': get_data_transform( "val", config )
    }

    # Create training and validation datasets
    image_datasets = {
        'trn': NormalizedImages( protocol_file, label_tags, folders=[0], transform = data_transforms['trn']  ),
        'val': NormalizedImages( protocol_file, label_tags, folders=[1], transform = data_transforms['val']  )
    }

    # Create training and validation dataloaders
    batch_size = config["optimizer"]["batch_size"]
    num_workers = config["optimizer"]["num_workers"]
    dataloaders = {
        x: torch.utils.data.DataLoader(image_datasets[x], batch_size=batch_size, shuffle=True, num_workers=num_workers)
        for x in ['trn', 'val'] } 

    # Gather and print the parameters to be optimized
    params_to_update = model.parameters()
    print("Params to learn:")
    for name, param in model.named_parameters():
        if param.requires_grad == True:
            print("\t", name)

    # Setup optimizer
    if config["optimizer"]["algo"] == "sgd":
        optimizer = optim.SGD(params_to_update, lr=config["optimizer"]["lr"], momentum=0.9)
    elif config["optimizer"]["algo"] == "adam":
        optimizer = optim.Adam(params_to_update, lr=config["optimizer"]["lr"], 
                    betas=config["optimizer"]["betas"],eps=config["optimizer"]["eps"])
    else:
        sys.exit(f"Unknown optimizer {config['optimizer']['algo']}")

    # Train and evaluate
    if args.dry is False:
        model, log_history = train_model( model, config, dataloaders, loss_matrix, optimizer, device, output_dir )
    else:
        # generate and store input images
        dry_training( config, dataloaders, output_dir )
        sys.exit( "Dry run...just generating a sample of training and validation inputs.")

    # Evaluate model on all data
    data_transform = get_data_transform( "val", config )
    image_dataset = NormalizedImages( protocol_file, label_tags, folders=[0,1,2], transform = data_transform, load_to_memory=False  )
    dataloader = torch.utils.data.DataLoader( image_dataset, batch_size=batch_size, shuffle=False, num_workers=num_workers)

    posterior, predicted_label, true_label, id, folder, error = eval_model( model, config, loss_matrix, dataloader, device )

    # Print errors
    print("Model evaluation:")
    for i, set in enumerate( error.keys() ):
        print(f"[{set} set]" )
        for head in config['heads']:
            print(f"{head['tag']} ({head['metric'][0]}): {error[set][head['tag']]:.4f}")


    # Save model
    #torch.save({'config': config,
    #            'split': args.split,
    #            'error': error,
    #            'error_history': error_history,
    #            'loss_history': loss_history,
    #            'model_state_dict': model.state_dict()}, model_fname )

    # Save evaluation
    torch.save({'config': config,
                'split': args.split,
                'error': error,
                'log_history': log_history,
                'posterior': posterior,
                'true_label': true_label,
                'predicted_label': predicted_label,
                'id': id,
                'folder': folder }, evaluation_fname )

    if device.type == 'cpu':
        model_scripted = torch.jit.script(model) # Export to TorchScript
        torch.jit.save(model_scripted, model_fname + "_cpu.pt", _extra_files={'config': yaml.dump(config)} )
        
    else:
        gpu_model_scripted = torch.jit.script(model) # Export to TorchScript
        torch.jit.save(gpu_model_scripted, model_fname + "_gpu.pt", _extra_files={'config': yaml.dump(config)} )

        cpu_model = model.cpu()        
        cpu_model_scripted = torch.jit.script(cpu_model) # Export to TorchScript
        torch.jit.save(cpu_model_scripted, model_fname + "_cpu.pt", _extra_files={'config': yaml.dump(config)} )

 