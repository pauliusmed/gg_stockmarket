# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2026-06-22

### Fixed
- Išvalyti visi užsilikę Git merge konfliktų žymekliai (`<<<<<<<`, `=======`, `>>>>>>>`) `server/server.lua` ir `client/client.lua` failuose.
- Pašalintas dubliuojantis kodas pirkimo (`buyStock`) apdorojimo logikoje.
- Atkurta teisinga pranešimų skaidymo logika klientinėje dalyje (`client.lua`).
- Išlaikyti visi pažangūs funkcionalumai iš `HEAD` šakos (tikslios kainos `preciseStockPrices`, mokesčių DB lentelės ir surinkimas, interaktyvūs slankikliai meniu, dinaminis blipų matomumas pagal darbo valandas).
- Ištaisyta indentacija pagalbiniam funkcijų blokui `server/server.lua` faile.
- Ištaisytas globalių kintamųjų nuotėkis (global leak) pridedant `local` prie `amountBuy` ir `amountSell` `client/client.lua` failo `calculatedTotal` įvykio apdorojime.
