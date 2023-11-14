select * 
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 3,4

-- Select data 

select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by 1,2

-- Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in asia

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%asia%'
order by 1,2

-- Total cases vs Population
-- Shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%asia%'
order by 1,2

-- Looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_population_Infected
from [Portfolio Project]..CovidDeaths
--where location like '%asia%'
group by location, population
order by Percent_population_Infected desc

-- Showing Countries With Highest Death Count Per Population

select location, MAX(cast(Total_deaths as int)) as Total_Death_Count
from [Portfolio Project]..CovidDeaths
where continent is not null
group by location
order by Total_Death_Count desc

-- By Continent

select location, MAX(cast(Total_deaths as int)) as Total_Death_Count
from [Portfolio Project]..CovidDeaths
where continent is null
group by location
order by Total_Death_Count desc

-- Global Numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2

--Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from popvsvac

-- Using Temp Table to perform Calculation on Partition By in previous query


DROP Table if exists #PercentPopulationVaccinated
create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/Population)*100
from #percentpopulationvaccinated


