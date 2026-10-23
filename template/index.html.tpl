<!doctype html>
<html lang="nl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{name}} – {{role_cap}}</title>
  <meta name="description" content="Tolk- en vertaaldiensten {{languages}} voor rechtbanken, advocaten, politie, gemeenten en particulieren.">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@500;600&family=Source+Sans+3:wght@400;600&display=swap">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header class="top">
    <div class="wrap bar">
      <a class="logo" href="#top"><img src="logo.svg" alt="{{name}}" height="48"></a>
      <nav aria-label="Hoofdmenu">
        <a href="#diensten">Diensten</a>
        <a href="#werkwijze">Werkwijze</a>
        <a href="#over-mij">Over mij</a>
        <a href="#contact">Contact</a>
      </nav>
    </div>
  </header>

  <main id="top">
    <section class="hero">
      <div class="wrap">
        <p class="eyebrow">{{role_cap}}</p>
        <h1>{{languages}}, nauwkeurig en onpartijdig</h1>
        <p class="lead">Voor rechtbanken, advocaten, politie, gemeenten en particulieren.</p>
        <a class="btn" href="#contact">Neem contact op</a>
      </div>
    </section>

    <section id="diensten" class="section">
      <div class="wrap">
        <h2>Diensten</h2>
        <div class="cols">
          <article>
            <h3>Tolken</h3>
            <p>Tolken ter plaatse, telefonisch of via een videoverbinding, bijvoorbeeld bij zittingen, verhoren, gesprekken met een advocaat en afspraken bij gemeenten of in de zorg.</p>
          </article>
          <article>
            <h3>Vertalen</h3>
            <p>Vertaling van officiële documenten, zoals akten, uittreksels, diploma’s, vonnissen, dagvaardingen en contracten, van het {{lang_a}} naar het {{lang_b}} en andersom.</p>
          </article>
          <article>
            <h3>Juridische opdrachten</h3>
            <p>Aandacht voor juridische terminologie en voor de onpartijdige houding die van een tolk in een juridische context wordt verwacht.</p>
          </article>
        </div>
      </div>
    </section>

    <section id="werkwijze" class="section tint">
      <div class="wrap">
        <h2>Werkwijze</h2>
        <ol class="steps">
          <li>
            <h3>Aanvraag</h3>
            <p>U stuurt de opdracht door, met de datum, de plaats en de taalcombinatie.</p>
          </li>
          <li>
            <h3>Offerte</h3>
            <p>U ontvangt vooraf een duidelijk tarief.</p>
          </li>
          <li>
            <h3>Uitvoering</h3>
            <p>De opdracht wordt nauwkeurig en onpartijdig uitgevoerd.</p>
          </li>
        </ol>
        <p class="note">Alle informatie wordt strikt vertrouwelijk behandeld.</p>
      </div>
    </section>

    <section id="over-mij" class="section">
      <div class="wrap split">
        <h2>Over mij</h2>
        <div>
          {{about_html}}
          <!-- Nog toe te voegen: opleiding, ervaring en, zodra van toepassing, inschrijving in het Rtv met inschrijfnummer. -->
        </div>
      </div>
    </section>

    <section id="contact" class="contact">
      <div class="wrap split">
        <h2>Contact</h2>
        <dl>
          <dt>E-mail</dt>
          <dd><a href="mailto:{{email}}">{{email}}</a></dd>
          <dt>Telefoon</dt>
          <dd><a href="tel:{{phone_tel}}">{{phone}}</a></dd>
{{extra_contact}}        </dl>
      </div>
    </section>
  </main>

  <footer>
    <div class="wrap">© <span id="y">2026</span> {{name}}</div>
  </footer>
  <script>document.getElementById('y').textContent = new Date().getFullYear();</script>
</body>
</html>
