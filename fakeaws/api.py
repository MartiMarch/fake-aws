from fakeaws.models.ProductDTO import ProductDTO
from fakeaws.adapters.dynamodb import DynamoDB
from fastapi import FastAPI
from typing import List
import uvicorn


api = FastAPI()
dynamodb = DynamoDB()

@api.get("/healthcheck")
async def healthcheck():
    return {"status": "ok"}


@api.post("/dynamodb", response_model=ProductDTO)
async def dynamodb_save(product_dto: ProductDTO):
    return dynamodb.save(product_dto)

@api.get("/dynamodb", response_model=List[ProductDTO])
async def dynamodb_list() -> List[ProductDTO]:
    return dynamodb.list()

@api.delete("/dynamodb/{product_id}")
async def delete_product(product_id: str) -> dict:
    return dynamodb.delete(product_id)

if __name__ == "__main__":
    uvicorn.run("fakeaws.api:api", host="0.0.0.0", port=8080, reload=True)
