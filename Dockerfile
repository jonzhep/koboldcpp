FROM python:3.10

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

# Create a models directory and download the Hugging Face model to it
RUN mkdir models
RUN pip install torch torchvision transformers
RUN python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; tokenizer = AutoTokenizer.from_pretrained('TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ'); model = AutoModelForCausalLM.from_pretrained('TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ'); model.save_pretrained('models/Wizard-Vicuna-13B-Uncensored-GPTQ')"

# Make port 80 available to the world outside this container
EXPOSE 80

# Use koboldcpp.py as the entrypoint when the container launches
ENTRYPOINT ["python", "koboldcpp.py"]