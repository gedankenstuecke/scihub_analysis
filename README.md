# SciHub Data Analysis
These are some scripts to analyse the data sets published by SciHub. You can find some analysis and texts about insights already won from the data at [Science](http://www.sciencemag.org/news/2016/04/whos-downloading-pirated-papers-everyone) and the [DataDryad Blog](https://blog.datadryad.org/2016/04/28/sci-hub-stories/).

## When are people downloading via SciHub?
Run `download_time_analysis.R` and pass one of the `*.tab` files, yields a `graphs/download_time.pdf`. Watch out: The time zones are not taken into account, everything's UTC. For that reason there are two filtered files in `graphs/`, one for Hong Kong (UTC+7) and one for Germany (UTC+1) as examples.

## Aggregate by country
Handling the complete files on my poor little notebook and in R was bit too much, so for looking at country-wise statistics I decided to calculate the aggregates the lazy bioinformatics-way:

`cut -f 4 *.tab|sort|uniq -c|sort -n|awk '{out=$1"\t"; for(i=2;i<=NF;i++){out=out" "$i}; print out}' > countrywise.csv`

### Compare Downloads per Country to Population Size
The [World Bank offers the Population Sizes for 214 countries/economies as of 2014](http://data.worldbank.org/data-catalog/Population-ranking-table), amongst other file types as a csv. I used those and for now manually matched those to the countries listed in the *SciHub* data. Results are in `country_downloads_population.csv` (If no match could be made I just removed the country for now). The population numbers are in 1.000's.

This file is used by `population_analysis.R` to analyze how the population size and number of downloads are connected (`graphs/downloads_per_population.pdf`). Fitting a glm on the data the script also gives you the residuals, ranking which countries have how much more/less downloads than one would expect (`graphs/downloads_per_population_residuals.pdf`).

Last but not least the script also gives you the number of downloads per 1.000 inhabitants (`graphs/downloads_per_population_ranked.pdf`).

## Dependencies
The R scripts use *ggplot2*, *ggrepel*, *ggthemes* and *lubridate*.

## Questions
### Where's the raw data?
It's available at DataDryad, so it's not included here. [Download it from there](http://dx.doi.org/10.5061/dryad.q447c).

### What are the timezones?
The times in the data set are all in UTC, so you'll have to adjust them for the corresponding time zones if interested in analyzing those. Or you could just ignore it for now as I did above, because I'm lazy.

### Can I Contribute?
Most definitely, I'm happy for everyone who likes to join me or has suggestions in what to analyze next! Get in touch through the issues or via [Twitter](http://www.twitter.com/gedankenstuecke).
