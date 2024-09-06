# **********************
#       Base Image      
# **********************
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime


# *********************
#     Env Variables    
# *********************

ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG USER_GNAME

ARG DEBIAN_FRONTEND=noninteractive


# **********************************
#   System-level Package Management  
# **********************************

# Install base utilities and common apt packages
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https ca-certificates apt-utils \
        software-properties-common build-essential \
        wget git vim ffmpeg cmake curl htop libssl-dev \
        nvtop net-tools pandoc tmux tree unrar unzip \
        libfontconfig1-dev pkg-config

# Anything else you want to do like clean up goes here *
RUN rm -rf /var/lib/apt/lists/* && \
    ldconfig && \
    apt autoremove && \
    apt clean


# **********************************
#   Python-level Package Management  
# **********************************

# Install Python packages
COPY requirements.txt /build/requirements.txt
RUN pip install -r /build/requirements.txt


# **********************
#   User Configuration  
# **********************

# Creates a new group with the specified GID and group name.
RUN groupadd --gid $USER_GID $USER_GNAME

# Creates a new user with the specified UID, GID, and username. The -m flag creates a home directory for the user.
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Updates the package list from the repositories and installs the sudo package.
RUN apt-get update && apt-get install -y sudo

# Configures the newly created user to have passwordless sudo access.
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME

# Sets the correct permissions for the sudoers file to ensure security.
RUN chmod 0440 /etc/sudoers.d/$USERNAME

# Changes the ownership of the home directory to the new user and group, ensuring that the user has the appropriate permissions for their home directory
RUN chown -R $USER_UID:$USER_GID /home/$USERNAME

#  Set the default user
USER $USERNAME


# *********************************
#  Working Directory Configuration
# *********************************

# Set directory
WORKDIR /workspace