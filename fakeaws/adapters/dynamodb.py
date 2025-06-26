from fakeaws.models.ProductMapper import ProductMapper
from fakeaws.models.ProductDTO import ProductDTO
from fakeaws.models.Product import Product
from decimal import Decimal
from typing import List
from uuid import UUID
import boto3


class DynamoDB:
    ENDPOINT = 'http://192.168.2.83:4566'
    TABLE = 'fake-aws-pre-dynamodb'

    def __init__(self):
        self._service = boto3.resource(
            'dynamodb',
            region_name='us-east-1',
            aws_access_key_id='fake',
            aws_secret_access_key='fake',
            endpoint_url=self.ENDPOINT,
        )

    @property
    def service(self):
        return self._service

    def delete(self, product_id: str):
        table = self.service.Table(self.TABLE)
        table.delete_item(
            Key={
                "productId": product_id
            },
            ReturnValues="ALL_OLD"
        )

        return {
            "status": "ok",
            "message": f"Product with id {product_id} deleted"
        }

    def save(self, product_dto: ProductDTO) -> ProductDTO:
        product = ProductMapper.dto_to_product(product_dto)
        products_table = self.service.Table('fake-aws-pre-dynamodb')
        products_table.put_item(
            Item={
                "productId": str(product.id),
                "company": product.company,
                "provider": product.provider,
                "price": Decimal(str(product.price)),
                "stock": product.stock,
            }
        )

        return ProductMapper.product_to_dto(product)

    def list(self) -> List[ProductDTO]:
        products_dto: list[ProductDTO] = []

        products_table = self.service.Table('fake-aws-pre-dynamodb')
        response = products_table.scan()
        items = response.get('Items', [])
        for item in items:
            product = Product(
                company=item.get('company'),
                provider=item.get('provider'),
                price=item.get('price'),
                stock=item.get('stock'),
            )
            product.id = UUID(item.get('productId'))
            product_dto: ProductDTO = ProductMapper.product_to_dto(product)
            products_dto.append(product_dto)

        return products_dto
