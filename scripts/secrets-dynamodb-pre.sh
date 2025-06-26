aws kms create-key \
  --endpoint-url='http://192.168.2.83:4566' \
  --description "Clave SSE para el DynamoDB de pre" \
  --tags TagKey=project,TagValue=fwk-aws-pr TagKey=env,TagValue=pre \
  --key-usage ENCRYPT_DECRYPT \
  --customer-master-key-spec SYMMETRIC_DEFAULT 

aws kms create-alias \
  --endpoint-url='http://192.168.2.83:4566' \
  --alias-name alias/fwk-aws-pre-dynamodb-sse \
  --target-key-id 0f291778-4cb1-43a2-bc5f-e47638b4854c

aws kms tag-resource \
  --endpoint-url='http://192.168.2.83:4566' \
  --key-id alias/fwk-aws-pre-dynamodb-sse \
  --tags TagKey=project,TagValue=fwk-fake TagKey=env,TagValue=pre
