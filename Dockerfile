# Use an official Python runtime as a parent image
FROM python:3.10

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Install necessary build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    libclblast-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# Compile the binaries using the Makefile
RUN make LLAMA_OPENBLAS=1 LLAMA_CLBLAST=1

# Make port 80 available to the world outside this container
EXPOSE 80

# Use koboldcpp.py as the entrypoint when the container launches
ENTRYPOINT ["python", "koboldcpp.py"]