SELECT *
FROM ProjectPortfolio..CovidDeaths 


--Total cases VS Total deaths updated for 11/14/2021
--Shows liklehood of dying from covid by country 
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Pec
FROM ProjectPortfolio..CovidDeaths 
where location='Israel';

--Looking at Total cases vs population 
--shows the present of infected pepole out of population
SELECT location,date,total_cases,population,(total_cases/population)*100 as InfactionRate
FROM ProjectPortfolio..CovidDeaths 
where location='Israel'
order by 2;

--shows the country with Highest infection rate 
SELECT location,MAX((total_cases/population)*100) as InfectionRate
FROM ProjectPortfolio..CovidDeaths 
where continent is not null
GROUP BY location
order by InfectionRate DESC;

--showing countries with Highest Death count 
SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths 
where continent is not null
GROUP BY location
order by TotalDeathCount DESC;

--Breaking down per continent
SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths 
where continent is null 
AND location IN ('World','Europe','Asia','South America','North America','Africa','Oceania')
GROUP BY location
order by TotalDeathCount DESC;

--GLOBAL Numbers
SELECT SUM(new_cases) as Total_cases,SUM(CAST(new_deaths as int)) as Total_deaths,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 AS DeathRate
FROM ProjectPortfolio..CovidDeaths
WHERE location= 'World'
order by 2 ASC; 


--Looking at total population that got vaccinated
WITH VAC_CTE AS(
SELECT dea.continent,dea.location,dea.date,dea.population,dea.new_cases,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as numeric)) OVER (PARTITION BY dea.location ORDER BY dea.date) as TotolVaccinated
FROM ProjectPortfolio..CovidVaccinations vac
join ProjectPortfolio..CovidDeaths dea
ON vac.location=dea.location
AND vac.date = dea.date 
WHERE dea.continent IS NOT NULL
)
SELECT * ,
(TotolVaccinated/population)*100 as VacRate
FROM VAC_CTE
where location='Israel'
ORDER BY 1,2 ;


--Creating View for Visualizations

--1)
Create View DeathPrecent as
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Pec
FROM ProjectPortfolio..CovidDeaths 

--2)
Create View InfactionRate as
SELECT location,date,total_cases,population,(total_cases/population)*100 as InfactionRate
FROM ProjectPortfolio..CovidDeaths 

--3)
Create View DeathCount as
SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths 
where continent is not null
GROUP BY location

--4)
Create View Covid_19_Global as
SELECT SUM(new_cases) as Total_cases,SUM(CAST(new_deaths as int)) as Total_deaths,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 AS DeathRate
FROM ProjectPortfolio..CovidDeaths
WHERE location= 'World'

--5)
Create View PopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,dea.new_cases,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as numeric)) OVER (PARTITION BY dea.location ORDER BY dea.date) as TotolVaccinated
FROM ProjectPortfolio..CovidVaccinations vac
join ProjectPortfolio..CovidDeaths dea
ON vac.location=dea.location
AND vac.date = dea.date 
WHERE dea.continent IS NOT NULL
