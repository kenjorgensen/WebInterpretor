FROM python:3.11-slim as python-base

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Create stage for Poetry installation
FROM python-base as poetry-base

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv  \
    && /bin/pip install -U pip setuptools \
    && /bin/pip install poetry==

# Create a new stage from the base python image
FROM python-base as example-app

# Copy Poetry to app image
COPY --from=poetry-base  

# Add Poetry to PATH
ENV PATH=":/bin"

WORKDIR /app

# Copy the project files into the container
COPY pyproject.toml poetry.lock ./

# [OPTIONAL] Validate the project is properly configured
RUN poetry check

# Install Dependencies
RUN poetry install --no-interaction --no-cache --without dev

# Copy the rest of the project files into the container
COPY . /app

# Install Poetry
# RUN pip install poetry



# Define the command to run your application
EXPOSE 8000
CMD ["poetry", "run", "python", "main.py"]
  
