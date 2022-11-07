create database [portfolio project]
select *
from CovidDeaths$
order by location, date

select *
from CovidVaccinations$
order by location, date

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by location, date

/* Death Percentage in India*/

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Percentage]
from CovidDeaths$
where location like 'india'
order by location, date

/*Total Cases vs Total Population
Shows what percentage of population got covid*/

select location, date, population, total_cases, (total_cases/population)*100 as [Population Infected],
from CovidDeaths$
order by location, date

/*Countries with Highest Infection Rate Compared to Population*/ 

select location, population, max(total_cases) as [Infection Rate], max(total_cases/population)*100 as [Population Infected]
from CovidDeaths$
group by location, population
order by [Population Infected] desc

/*Countries with Highest Death Count per Population*/

select location, MAX(cast(total_deaths as int)) as [Total Death Count]
from CovidDeaths$
where continent is not null
group by location
order by [Total Death Count] desc

/* Highest Death Count grouped by Continents*/

select continent, MAX(cast(total_deaths as int)) as [Total Death Count]
from CovidDeaths$
where continent is not null
group by continent
order by [Total Death Count]desc

/*GLOBAL NUMBERS*/

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as [death percentage]
from CovidDeaths$
where continent is not null
group by date

/* JOINS*/
/* Total Population vs Total Vaccinations*/

select deaths.continent, deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations, SUM(convert(int, vaccines.new_vaccinations)) over ( partition by deaths.location order by deaths.location, deaths.date) as [Partitioned data]
from CovidDeaths$ deaths
join CovidVaccinations$ vaccines
on deaths.location = vaccines.location and deaths.date = vaccines.date
where deaths.continent is not null
order by location, date
