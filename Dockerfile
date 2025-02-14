FROM python:3.9

WORKDIR /code

# Copy requirements first to leverage Docker caching
COPY ./requirements.txt /code/requirements.txt

# Install dependencies
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    apt-transport-https \
    ca-certificates \
    gnupg

# Install Google Cloud SDK
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
    && mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh

# Add Google Cloud SDK to PATH
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install gke-gcloud-auth-plugin
RUN gcloud components install gke-gcloud-auth-plugin --quiet

# Verify installation
RUN gcloud --version && gke-gcloud-auth-plugin --version

# Copy application code
COPY . /code

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
