from pydantic import BaseModel


class ProductDTO(BaseModel):
    productId: str = None
    company: str
    provider: str
    price: float
    stock: int
