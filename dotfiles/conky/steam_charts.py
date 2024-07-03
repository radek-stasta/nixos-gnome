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
    steamNew = '${font Ubuntu Mono:style=Bold:size=14}${alignc}NEW${font}\n\n'
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

        paddedName = game['name'].ljust(32)
        paddedPeak = game['peak'].rjust(8)

        steamNew += '${color ' + color + '}' + paddedName + ' | ' + paddedPeak + '\n'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_new.txt', 'w+')
    outputFile.write(steamNew)
    outputFile.close()

    # HOT
    tableHotReleases = productsRows[1].findAll("table", {"class": "table-products"})[1]
    appRows = tableHotReleases.find_all("tr", {"class": "app"})

    newTrending = []

    for app in appRows:
        columns = app.find_all("td")
        name = columns[1].find("a", {"class": "css-truncate"}).get_text(strip=True)
        name = (name[:30] + '..') if len(name) > 30 else name
        rating = columns[2].get_text()
        price = columns[3].get_text()
        gameInfo = {"name": name, "rating": rating, "price": price}
        newTrending.append(gameInfo)

    now = datetime.now()
    steamNewTrending = '${font Ubuntu Mono:style=Bold:size=14}${alignc}NEW TRENDING${font}\n\n'
    for game in newTrending:
        # color games based on peak
        rating = float(game['rating'].replace(',', '').replace('%', ''))
        color = "#BF616A"
        if (rating >= 90):
            color = "#A3BE8C"
        elif (rating >= 87):
            color = "#8FBCBB"
        elif (rating >= 84):
            color = "#EBCB8B"
        elif (rating >= 81):
            color = "#D08770"

        paddedName = game['name'].ljust(32)
        paddedRating = game['rating'].rjust(8)

        steamNewTrending += '${color ' + color + '}' + paddedName + ' | ' + paddedRating + '\n'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_new_trending.txt', 'w+')
    outputFile.write(steamNewTrending)
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

    steamTrending = '${font Ubuntu Mono:style=Bold:size=14}${alignc}TRENDING${font}\n\n'
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

        paddedName = game['name'].ljust(32)
        paddedPlayers = game['players'].rjust(8)

        steamTrending += '${color ' + color + '}' + paddedName + ' | ' + paddedPlayers + '\n'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_trending.txt', 'w+')
    outputFile.write(steamTrending)
    outputFile.close()

finally:
    try:
        driver.quit()
    except:
        pass

try:
    # UPCOMING
    options = Options()
    options.add_argument('--no-sandbox')
    #options.add_argument("--headless=new")
    driver = webdriver.Firefox(options=options)
    driver.get("https://steamdb.info/upcoming/?nosmall")
    bs = BeautifulSoup(driver.page_source, "html.parser")

    body = bs.find("div", {"class": "body-content"})
    releasesContainer = body.find("div", {"class": "container"}, recursive=False)

    releases = []

    # Get first 20 dates
    dates = releasesContainer.find_all("div", {"class": "pre-table-title"})
    releasesIndex = 0

    for date in dates:
        dateText = date.find("a").find_all(string=True, recursive=False)[-1].strip()
        dateObject = datetime.strptime(dateText, '%d %B %Y')
        formattedDate = dateObject.strftime('%d.%m.%Y')
        releases.append({"date": formattedDate, "games": []})
        releasesIndex = releasesIndex + 1
        if releasesIndex >= 20:
            break

    # Assign first 20 game lists to dates
    games = releasesContainer.find_all("div", {"class": "dataTable_table_wrap"})
    releasesIndex = 0

    for game in games:
        appRows = game.find_all("tr", {"class": "app"})
        for app in appRows:
            gameInfo = {}
            name = app.find('a', {"class": "b"}).get_text(strip=True)
            name = (name[:30] + '..') if len(name) > 30 else name
            followers = app.find('td', {"class": "text-center"}).get_text(strip=True)
            gameInfo = {"name": name, "followers": followers}
            releases[releasesIndex]["games"].append(gameInfo)

        # sort games by number of followers
        releases[releasesIndex]["games"] = sorted(releases[releasesIndex]["games"], key=lambda x: int(x['followers'].replace(',', '')), reverse=True)

        releasesIndex = releasesIndex + 1
        if releasesIndex >= 20:
            break

    releasesIndex = 0
    totalGamesPrinted = 0 # limit to 10 games

    # Print upcoming releases
    steamUpcoming = '${font Ubuntu Mono:style=Bold:size=14}${alignc}UPCOMING${font}\n\n'
    for releaseDay in releases:
        # Check if at least one game have more than 1000 followers
        if int(releaseDay['games'][0]['followers'].replace(',', '')) >= 1000:
            steamUpcoming += '${color #B48EAD}${font Ubuntu Mono:style=Bold:size=13}${alignc}' + releaseDay['date'] + '${font}\n'
            for gameRelease in releaseDay['games']:
                followers = int(gameRelease['followers'].replace(',', ''))
                if followers >= 1000:
                    # color games based on followers
                    color = "#BF616A"
                    if (followers >= 20000):
                        color = "#A3BE8C"
                    elif (followers >= 10000):
                        color = "#8FBCBB"
                    elif (followers >= 5000):
                        color = "#EBCB8B"
                    elif (followers >= 3000):
                        color = "#D08770"

                    paddedName = gameRelease['name'].ljust(32)
                    paddedFollowers = gameRelease['followers'].rjust(8)

                    steamUpcoming += '${color ' + color + '}' + paddedName + ' | ' + paddedFollowers + '\n'

                    # limit to 25printed games
                    totalGamesPrinted = totalGamesPrinted + 1
                    if totalGamesPrinted >= 25:
                        releasesIndex = 10
                        break

            steamUpcoming += "\n"
            releasesIndex = releasesIndex + 1

        if releasesIndex >= 10:
            break

    now = datetime.now()
    steamUpcoming += '${color #B48EAD}${alignc}' + '(' + now.strftime("%d.%m.%Y %H:%M:%S") + ')'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_upcoming.txt', 'w+')
    outputFile.write(steamUpcoming)
    outputFile.close()

finally:
    try:
        driver.quit()
    except:
        pass