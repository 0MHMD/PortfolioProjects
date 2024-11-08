SELECT * 
FROM PortofolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortofolioProject..CovidVaccination
--ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortofolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location,date


--Total Cases Vs Total Deaths
SELECT location,date,total_cases,total_deaths,
	CASE WHEN total_cases=0 THEN 0
	ELSE (total_deaths/total_cases)*100
	END AS DeathPercentage
FROM PortofolioProject.dbo.CovidDeaths
WHERE location = 'Egypt'
	  AND continent IS NOT NULL
ORDER BY location,date

--Total cases Vs Population
SELECT location,date,population,total_cases,
	   (total_cases/population)*100 AS Cases_Percentage
FROM PortofolioProject.dbo.CovidDeaths
WHERE location = 'Egypt'
	  AND continent IS NOT NULL
ORDER BY location,date

-- hihest infiction rate 
SELECT location ,population ,MAX(total_cases) AS PopInfectionCount,
	   MAX((total_cases/population)*100) AS PopInficationRate
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PopInficationRate desc

-- countries by Death Count
SELECT location ,MAX(total_deaths) AS TotalDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc

--continent by Death Count
SELECT location,MAX(total_deaths) AS TotalDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount desc

-- Global numbers
SELECT SUM(new_cases) AS total_cases,SUM(new_deaths) AS total_deaths,
		SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM PortofolioProject.dbo.CovidDeaths

WHERE continent IS NOT NULL
ORDER BY 1,2

--population vs vaccination
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	   SUM(cast(vac.new_vaccinations as bigint))OVER(PARTITION BY dea.location
			ORDER BY dea.location,dea.date) AS RollingPeapleVaccinated,
		(SUM(cast(vac.new_vaccinations as bigint))OVER(PARTITION BY dea.location
		ORDER BY dea.location,dea.date)/dea.population)*100
FROM PORTOFOLIOPROJECT..CovidDeaths AS dea
join PORTOFOLIOPROJECT..CovidVaccination AS vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
ORDER BY 2,3 




with PopVsVac (continent,location,date,population,new_vaccinations,RollingPeapleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	   SUM(cast(vac.new_vaccinations as bigint))OVER(PARTITION BY dea.location
			ORDER BY dea.location,dea.date) AS RollingPeapleVaccinated
FROM PORTOFOLIOPROJECT..CovidDeaths AS dea
join PORTOFOLIOPROJECT..CovidVaccination AS vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
--ORDER BY 2,3 
)
SELECT * ,(RollingPeapleVaccinated/population)*100 AS vaccinatedRatio
FROM PopVsVac


--Views for the visualization 
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	   SUM(cast(vac.new_vaccinations as bigint))OVER(PARTITION BY dea.location
			ORDER BY dea.location,dea.date) AS RollingPeapleVaccinated
FROM PORTOFOLIOPROJECT..CovidDeaths AS dea
join PORTOFOLIOPROJECT..CovidVaccination AS vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
--ORDER BY 2,3 


