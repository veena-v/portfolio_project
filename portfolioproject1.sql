create database PortfolioProject;

use PortfolioProject;



create table CovidDeaths(
iso_code varchar(10),
continent varchar(20),
location varchar(40),
dates date,
population BIGINT,
total_cases int,
new_cases int,
new_cases_smoothed int,
total_deaths int,
new_deaths int ,
new_deaths_smoothed float,
total_cases_per_million float,
new_cases_per_million float,
new_cases_smoothed_per_million float,
total_deaths_per_million float,
new_deaths_per_million float,
new_deaths_smoothed_per_million float,
reproduction_rate float,
icu_patients int,
icu_patients_per_million float,
hosp_patients int,
hosp_patients_per_million float,
weekly_icu_admissions int,
weekly_icu_admissions_per_million float,
weekly_hosp_admissions int,
weekly_hosp_admissions_per_million float

);

select count(*) from coviddeaths;
select * from coviddeaths
-- where continent is not null
limit 309605;

create table CovidVaccination(
iso_code varchar(10),
continent varchar(20),
location varchar(40),
dates date,
population BIGINT,
total_tests int,
new_tests int,
total_tests_per_thousand float,
new_tests_per_thousand float,
new_tests_smoothed BIGINT,
new_tests_smoothed_per_thousand float,
positive_rate float,
tests_per_case float,
tests_units varchar(60),
total_vaccinations BIGINT,
people_vaccinated BIGINT,
people_fully_vaccinated BIGINT,
total_boosters BIGINT,
new_vaccinations BIGINT,
new_vaccinations_smoothed BIGINT,
total_vaccinations_per_hundred float,
people_vaccinated_per_hundred float,
people_fully_vaccinated_per_hundred float,
total_boosters_per_hundred float,
new_vaccinations_smoothed_per_million BIGINT,
new_people_vaccinated_smoothed BIGINT,
new_people_vaccinated_smoothed_per_hundred  float,
stringency_index float,
population_density float,
median_age float,
aged_65_older float,
aged_70_older float,
gdp_per_capita float,
extreme_poverty float,
cardiovasc_death_rate float,
diabetes_prevalence float,
female_smokers float,
male_smokers float,
handwashing_facilities float,
hospital_beds_per_thousand float,
life_expectancy float,
human_development_index float,
excess_mortality_cumulative_absolute float,
excess_mortality_cumulative float,
excess_mortality float,
excess_mortality_cumulative_per_million float
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidVaccination.csv'
INTO TABLE CovidVaccination
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;



select count(*) from covidvaccination;

select * from PortfolioProject.covidvaccination
LIMIT  196252;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv'
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SHOW VARIABLES LIKE "secure_file_priv";

select location,dates,total_cases,new_cases, total_deaths, population
from coviddeaths
limit 309605;

-- shows the likehood if you contract covid in your country
select location,dates,total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
from coviddeaths
where location like '%states%'
limit 500000;

select location,dates,total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
from coviddeaths
where location like '%India%'
limit 500000;

-- shows what percentage of population got covid
select location,dates,total_cases, population, (total_cases/population) *100 as PercentageofPopulationInfected
from coviddeaths
-- where location like '%states%'
limit 500000;

-- Looking at countries with highest infection rate compared to population
select location,population, max(total_cases) as highestinfectioncount,  max((total_cases/population)) *100 as PercentageofPopulationInfected
from coviddeaths
group by location,population
order by PercentageofPopulationInfected desc;

-- showing countries with highest death count per population
select  distinct location, continent, population, MAX(total_deaths) as totaldeathcount
from coviddeaths
where continent != '' and continent != '0'
group by location, population, continent
order by totaldeathcount desc;

-- continents
select location,MAX(total_deaths) as totaldeathcount
from coviddeaths
where continent in ('','0')
group by location
order by totaldeathcount desc;

-- showing continents with highest death count per population
select location , population, MAX(total_deaths/population) as totaldeathcount
from coviddeaths
where continent in ('','0')
group by location, population
order by totaldeathcount desc;

-- global numbers
select dates, sum(new_cases) as Totalcases, sum(new_deaths) Totaldeaths, sum(new_deaths)/sum(new_cases) * 100 as DeathPercentage
from coviddeaths
where continent not in ('','0')
group by dates;

select sum(new_cases) as Totalcases, sum(new_deaths) Totaldeaths, sum(new_deaths)/sum(new_cases) * 100 as DeathPercentage
from coviddeaths
where continent not in ('','0');

select * from PortfolioProject.covidvaccination
LIMIT  196252;


with cte (Continent, Location, Dates, Population, New_Vaccinations, Sum_Of_Vaccination)
as (
select cd.continent, cd.location, cd.dates, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.dates) as sum_of_vaccination
 from PortfolioProject.coviddeaths cd
join PortfolioProject.covidvaccination cv 
on cd.location = cv.location
and   cd.dates = cv.dates
where cd.continent not in ('','0')
)
select *, (Sum_Of_Vaccination/Population) * 100 from cte;