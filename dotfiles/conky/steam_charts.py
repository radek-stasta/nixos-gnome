import os
from datetime import datetime
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

try:
    # NEW
    options = Options()
    options.add_argument('--no-sandbox')
    #options.add_argument("--headless=new")
    driver = webdriver.Firefox(options=options)
    driver.get("https://steamdb.info/")
    bs = BeautifulSoup(driver.page_source, "html.parser")

    productsContainer = bs.find("div", {"class": "container-products"})
    productsRows = productsContainer.find_all("div", {"class": "row"})

    tablePopularReleases = productsRows[1].find("table", {"class": "table-products"})
    appRows = tablePopularReleases.find_all("tr", {"class": "app"})

    new = []

    for app in appRows:
        columns = app.find_all("td")
        name = columns[1].find("a", {"class": "css-truncate"}).get_text(strip=True)
        name = (name[:30] + '..') if len(name) > 30 else name
        peak = columns[2].get_text()
        price = columns[3].get_text()
        gameInfo = {"name": name, "peak": peak, "price": price}
        new.append(gameInfo)

    now = datetime.now()
    steamNew = 'NEW\n'
    for game in new:
        # color games based on peak
        peak = int(game['peak'].replace(',', ''))
        color = "#BF616A"
        if (peak >= 10000):
            color = "#A3BE8C"
        elif (peak >= 5000):
            color = "#8FBCBB"
        elif (peak >= 3000):
            color = "#EBCB8B"
        elif (peak >= 1000):
            color = "#D08770"
        steamNew += '${color ' + color + '}' + game['name'] + ' | ' + game['peak'] + '\n'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_new.txt', 'w+')
    outputFile.write(steamNew.replace('&', '&amp;'))
    outputFile.close()

    # TRENDING
    firstRowTables = productsRows[0].find_all("table", {"class": "table-products"})
    tableTrending = firstRowTables[1]
    appRows = tableTrending.find_all("tr", {"class": "app"})

    trendig = []

    for app in appRows:
        columns = app.find_all("td")
        name = columns[1].find("a", {"class": "css-truncate"}).get_text(strip=True)
        name = (name[:30] + '..') if len(name) > 30 else name

        try:
            players = columns[3].get_text()
        except:
            players = "0"

        gameInfo = {"name": name, "players": players}
        trendig.append(gameInfo)

    # Sort by players
    trendig = sorted(trendig, key=lambda x: int(x['players'].replace(',', '')), reverse=True)

    steamTrending = 'TRENDING\n'
    for game in trendig:
        # color games based on peak
        players = int(game['players'].replace(',', ''))
        color = "#BF616A"
        if (players >= 10000):
            color = "#A3BE8C"
        elif (players >= 5000):
            color = "#8FBCBB"
        elif (players >= 3000):
            color = "#EBCB8B"
        elif (players >= 1000):
            color = "#D08770"
        steamTrending += '${color ' + color + '}' + game['name'] + ' | ' + game['players'] + '\n'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_trending.txt', 'w+')
    outputFile.write(steamTrending.replace('&', '&amp;'))
    outputFile.close()

finally:
    try:
        driver.quit()
    except:
        pass