import uuid


class Product:

    def __init__(self, company: str, provider: str, price: float, stock: int):
        self._id = uuid.uuid4()
        self._company = company
        self._provider = provider
        self._price = price
        self._stock = stock

    @property
    def id(self) -> uuid.UUID:
        return self._id

    @id.setter
    def id(self, id: uuid.UUID):
        self._id = id

    @property
    def company(self) -> str:
        return self._company

    @company.setter
    def company(self, company: str):
        self._company = company

    @property
    def provider(self) -> str:
        return self._provider

    @provider.setter
    def provider(self, provider: str):
        self._provider = provider

    @property
    def name(self) -> str:
        return self._company

    @name.setter
    def name(self, name: str):
        self._company = name

    @property
    def price(self) -> float:
        return self._price

    @price.setter
    def price(self, price: float):
        self._price = price

    @property
    def stock(self) -> float:
        return self._stock

    @stock.setter
    def stock(self, stock: float):
        self._stock = stock
