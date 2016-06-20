BASE_DIR = 'output/'
BASE_URL = 'www.viovet.co.uk'
FULL_URL = 'https://www.viovet.co.uk'
PAGINATION = '?_=X&page='
CSV_HEADER = %w(Название Цена Картинка Доставка Код)

#XPATH
PAGINATION_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "pagination")]'
FAMILIES_LIST_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "families-list")]'
VIEW_DETAILS_XPATH = '//a[contains(concat( " ", normalize-space(@class), " " ), "call_to_action") 
                     and contains(concat( " ",  normalize-space(@class), " " ), "_secondary") 
                     and contains(concat( " ", normalize-space(@class), " " ), "_medium") 
                     and contains(concat( " ", normalize-space(@class), " " ), "view_details")]'
CONTENT_BOX_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "content-box")]'
PRODUCT_FAMILY_HEADING_XPATH = '//*[(@id = "product_family_heading")]'
IMG_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "img")]/@src'
PRODUCT_XPATH = '//li[contains(concat( " ", @class, " " ), concat( " ", "product", " " ))]'

#ITEM PATH
NODE_A = 'a'
ATTR_HREF = 'href'
FILLING_TITLE_PATH = 'div.title'
PRICE_PATH = 'div.ours span'
DELIVERY_PATH = '.in-stock'
CODE_PATH = 'a strong'

#ITEM XPATH
# FILLING_TITLE_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "title")]'
# OURS_PRICE_XPATH = '//*[contains(concat( " ", normalize-space(@class), " " ), "ours")]//span'
# DELIVERY_IN_STOCK_XPATH = '//strong[contains(concat( " ", normalize-space(@class), " " ), "stock")
# 						     and contains(concat( " ", normalize-space(@class), " " ), "in-stock")] '
# CODE_XPATH = '//a//strong'
