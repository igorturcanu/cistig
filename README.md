# Websites voor tolken en vertalers

Eén sjabloon (`template/`) en per klant een klein bestand in `clients/`. Het script maakt daarvan een website, een logo en een visitekaartje.

## Een nieuwe klant toevoegen

1. Kopieer `clients/madi-popescu.json` naar `clients/<naam>.json`.
2. Pas de velden aan: `name`, `initials`, `role`, `lang_a`, `lang_b`, `email`, `phone`, `about`.
   Optioneel: `kvk`, `rtv` (komen in het blok "Registratie"), `role_short`, `lang_codes`, `facts` (het blok "In het kort"), `navy` en `gold` (andere kleuren).
3. Draai `python3 build.py clients/<naam>.json`.
4. De map `sites/<naam>/` bevat alles: `index.html`, `style.css`, `logo.svg`, `logo-contact.svg`, `visitekaartje.svg`.

De teksten zijn geschreven in de ik-vorm. Controleer `about` altijd zelf op spelling en op wat de klant werkelijk mag vermelden. Gebruik alleen "beëdigd" als de klant in het Rtv staat ingeschreven.

## Online zetten

De map `sites/<naam>/` is een gewone statische website zonder build-stap. Hij kan op elke gratis statische hosting (GitHub Pages, Netlify, Cloudflare Pages) en is daarna voor iedereen te openen zonder account.

## Factuur

Elke site bevat ook `factuur.html`: een factuur die de klant zelf invult, met automatische berekening van het bedrag, de BTW en de uiterste betaaldatum, en een kant-en-klare e-mailtekst. "Opslaan als PDF" gebruikt de afdrukfunctie van de browser. Adres, BTW-nummer en IBAN worden alleen in de browser van de gebruiker onthouden en staan dus niet in dit (openbare) repo. De pagina is niet gelinkt vanaf de website en staat op `noindex`; de bezoeker kan haar alleen openen als hij het adres kent.
