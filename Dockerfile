FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    apt-transport-https \
    ca-certificates \
    gnupg

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz


# Installing the package
RUN mkdir -p /usr/local/gcloud \
&& tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
&& /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install gke-gcloud-auth-plugin
RUN gcloud components install gke-gcloud-auth-plugin --quiet

COPY . /code

CMD ["fastapi", "run", "--host", "0.0.0.0", "--port", "8000"]