aws dynamodb create-table \
  --endpoint-url='http://192.168.2.83:4566' \
  --table-name fake-aws-pre-dynamodb \
  --attribute-definitions \
      AttributeName=productId,AttributeType=S \
      AttributeName=company,AttributeType=S \
      AttributeName=provider,AttributeType=S \
  --key-schema \
      AttributeName=productId,KeyType=HASH \
  --global-secondary-indexes '[
  {
    "IndexName": "IndexCompany",
    "KeySchema": [
      {"AttributeName": "company", "KeyType": "HASH"}
    ],
    "Projection": {
      "ProjectionType": "ALL"
    },
    "ProvisionedThroughput": {
        "ReadCapacityUnits": 10,
        "WriteCapacityUnits": 5
    }
  },
  {
    "IndexName": "IndexProveder",
    "KeySchema": [
      {"AttributeName": "provider", "KeyType": "HASH"}
    ],
    "Projection": {
      "ProjectionType": "ALL"
    },
    "ProvisionedThroughput": {
      "ReadCapacityUnits": 10,
      "WriteCapacityUnits": 5
    }
  }]' \
  --billing-mode PROVISIONED \
  --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=5 \
  --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES \
  --sse-specification Enabled=true,SSEType=KMS,KMSMasterKeyId=alias/fwk-aws-pre-dynamodb-sse
  --tags Key=project,Value=fwk-aws-pre Key=env,Value=pre
