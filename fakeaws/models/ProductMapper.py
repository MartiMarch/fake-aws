from fakeaws.models.ProductDTO import ProductDTO
from fakeaws.models.Product import Product


class ProductMapper:

    @classmethod
    def product_to_dto(cls, product: Product) -> ProductDTO:
        return ProductDTO(
            productId=str(product.id),
            company=product.company,
            provider=product.provider,
            price=product.price,
            stock=product.stock
        )

    @classmethod
    def dto_to_product(cls, dto: ProductDTO) -> Product:
        product = Product(
            company=dto.company,
            provider=dto.provider,
            price=dto.price,
            stock=dto.stock
        )
        if dto.productId is not None:
            product.productId = dto.productId

        return product
