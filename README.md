# Formula 1 Data Analysis (1950–2024)

A SQL-focused analysis of Formula 1 history using the Ergast dataset.
The project covers the **2021 season in depth** and a set of **all-time
statistics**, built with MySQL for the analysis and Python for
visualisation.

## Question

Two angles:
- **2021 season** — how did the title fight unfold, and how did teammates
  compare across the year?
- **All-time** — who are the most dominant drivers and teams in F1 history?

## Dataset

[Ergast Motor Racing Database](https://ergast.com/mrd/) — a relational
dataset of F1 results from 1950 onward (~13 tables: races, results,
drivers, constructors, qualifying, pit stops, lap times, etc.).
Loaded into a local MySQL database.

## Tools

- **MySQL** — all data analysis (the core of the project)
- **Python** (pandas, SQLAlchemy, matplotlib) — querying the database
  and building visualisations
- **Jupyter Notebook** — combining queries, results and charts

## SQL techniques demonstrated

- Window functions — running totals (`SUM() OVER`), per-race ranking
  (`RANK()`)
- Conditional aggregation — win counts with `CASE WHEN`
- CTEs (`WITH`) — structuring multi-step queries
- Self-joins — teammate head-to-head comparisons
- Date bucketing — grouping seasons into decades
- Data-quality handling — `positionOrder` vs `position`, excluding
  pit-lane starts (`grid = 0`), `HAVING` vs `WHERE`

## Key findings

- **Ferrari's 2000s dominance** — Ferrari's win count peaks sharply in
  the 2000s decade, reflecting the Schumacher era.
- **Juan Manuel Fangio tops the all-time win rate** — with a minimum of
  50 races applied, Fangio ranks first by win percentage, ahead of the
  modern greats.
- **Verstappen's 18-place comeback** — the largest single-race position
  gain of 2021 (start position minus finish position).

## How to run

1. Download the Ergast MySQL dump and import it into a database named `f1db`.
2. Update the connection string in the notebook with your MySQL credentials.
3. Run the notebook cells (or the queries in `queries.sql` directly in MySQL).

## Files

- `f1_analysis.ipynb` — notebook with queries and charts
- `queries.sql` — all SQL queries, commented
