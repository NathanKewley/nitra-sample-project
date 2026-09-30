import os
import sys

# Nitra passes the details of the deployment to hooks as NITRA_* environment variables.
# Any az command run here already targets NITRA_SUBSCRIPTION, no --subscription needed.
for name in ["NITRA_CONFIGURATION", "NITRA_SUBSCRIPTION", "NITRA_SUBSCRIPTION_ID", "NITRA_RESOURCE_GROUP", "NITRA_LOCATION", "NITRA_DEPLOYMENT_NAME"]:
    print(f"{name}={os.environ.get(name, '')}")

# A non-zero exit code stops the deployment
sys.exit(0)
