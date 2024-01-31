FROM python:3.11-slim as python-base

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Set Chrome and ChromeDriver versions
ENV CHROME_VERSION="123.0.6167.85"
ENV CHROMEDRIVER_VERSION="123.0.6167.85"

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget unzip \
    libglib2.0-0 \
    libnss3 \
    libnss3-tools \
    libnspr4 \
    libxcb1 \
    libdbus-1-3 \   
    libatk1.0-0 \  
    libatk-bridge2.0-0 \   
    libcups2 \  
    libdrm2 \  
    libxkbcommon0 \   
    libxcomposite1 \  
    libxdamage1 \ 
    libxfixes3 \  
    libxrandr2 \  
    libgbm1 \ 
    libpango1.0-0 \
    libasound2  

# https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chrome-linux64.zip
# https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chromedriver-linux64.zip
# https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chrome-headless-shell-linux64.zip

# Install Google Chrome Headless Shell
RUN wget -q https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chrome-headless-shell-linux64.zip -P /tmp/ && \
    unzip /tmp/chrome-headless-shell-linux64.zip -d /opt/ && \
    ln -s /opt/chrome-headless-shell-linux64/chrome /usr/local/bin/chrome



# Download and install ChromeDriver
RUN wget -N https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chromedriver-linux64.zip -P ~/ && \
    unzip ~/chromedriver-linux64.zip -d ~/ && \
    mv -f ~/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chown root:root /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver

# Install Poetry using pip
RUN apt-get update && \
    apt-get install -y curl && \
    pip install "poetry==$POETRY_VERSION"

# Set the PATH environment variable to include /opt/chrome-linux64
ENV PATH="/opt/chrome-headless-shell-linux64:${PATH}"

# Set the working directory to /app
WORKDIR /app

# Copy the project files (pyproject.toml and poetry.lock) into the container
COPY pyproject.toml poetry.lock* /app/

# Install project dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-cache --without dev

# Copy the rest of the project files into the container
COPY . /app

# Expose the port the app runs on
EXPOSE 8000

# Define the command to run the application
CMD ["poetry", "run", "python", "main.py"]

