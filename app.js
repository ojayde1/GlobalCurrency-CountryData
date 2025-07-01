const express = require('express');
const axios = require('axios');
const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// Function to get country data (population, GDP, currency)
async function getCountryData(country) {
  try {
    const response = await axios.get(`https://restcountries.com/v3.1/name/${country}`);
    const data = response.data[0];
    return {
      name: data.name.common,
      population: data.population,
      currency: Object.keys(data.currencies || {})[0],
      currencyName: Object.values(data.currencies || {})[0]?.name,
      region: data.region,
      capital: data.capital?.[0]
    };
  } catch (error) {
    console.error('Error fetching country data:', error.message);
    return null;
  }
}

// Function to get exchange rate
async function getExchangeRate(currency) {
  try {
    const response = await axios.get(`https://api.exchangerate-api.com/v4/latest/USD`);
    const rate = response.data.rates[currency];
    return rate ? (1 / rate).toFixed(4) : null;
  } catch (error) {
    console.error('Error fetching exchange rate:', error.message);
    return null;
  }
}



app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Country Information Dashboard</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
            input, button { padding: 10px; margin: 5px; font-size: 16px; }
            input { width: 300px; }
            button { background: #007cba; color: white; border: none; cursor: pointer; }
            .result { margin-top: 20px; padding: 15px; background: #f5f5f5; border-radius: 5px; }
        </style>
    </head>
    <body>
        <h1>Country Information Dashboard</h1>
        <form method="POST" action="/check">
            <input type="text" name="country" placeholder="Enter country name" required>
            <button type="submit">Get Country Information</button>
        </form>
    </body>
    </html>
  `);
});

app.post('/check', async (req, res) => {
  const country = req.body.country.trim();
  
  const countryData = await getCountryData(country);
  
  let exchangeRate = null;
  if (countryData?.currency) {
    exchangeRate = await getExchangeRate(countryData.currency);
  }
  
  let content = '';
  
  if (countryData) {
    content += `
      <div class="result">
        <h3>📊 Country Information</h3>
        <p><strong>Capital:</strong> ${countryData.capital || 'N/A'}</p>
        <p><strong>Population:</strong> ${countryData.population.toLocaleString()}</p>
        <p><strong>Region:</strong> ${countryData.region}</p>
        <p><strong>Currency:</strong> ${countryData.currencyName} (${countryData.currency})</p>
        ${exchangeRate ? `<p><strong>Exchange Rate:</strong> 1 USD = ${(1/exchangeRate).toFixed(2)} ${countryData.currency}</p>` : ''}
      </div>`;
  }
  
  if (!countryData) {
    content = `
      <div class="result">
        <p>No information found for "${country}". Please check the spelling and try again.</p>
      </div>`;
  }
  
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Country Information</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 700px; margin: 50px auto; padding: 20px; }
            .result { margin-top: 20px; padding: 15px; background: #f5f5f5; border-radius: 5px; }
            a { color: #007cba; text-decoration: none; }
        </style>
    </head>
    <body>
        <h1>Information for ${countryData?.name || country}</h1>
        ${content}
        <p><a href="/">← Check another country</a></p>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});