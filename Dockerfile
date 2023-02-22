# Use an official Python runtime as a parent image
FROM python:3.10.6

# Set the working directory to /app
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js and npm
RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq curl git nano
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -yq nodejs build-essential
RUN npm install -g npm

# Copy the rest of the application code into the container at /app
COPY . .

# Build the frontend
RUN cd leadmanager/frontend && npm install --force && npm run build

# Expose port 8000 for the Django server
EXPOSE 8000

WORKDIR /app/leadmanager

# Start the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]