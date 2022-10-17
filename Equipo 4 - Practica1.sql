/*
   Grupo 3TV2 Bases de Datos Distribuidas
   Práctica 1
   Alvarez Garcia Elian Alexander
   Diego Vertiz Alexis
   Gallardo Cervantes Mario Abraham
   

   B). Segmentar la base de datos CovidHistorico por
   regiones
   C). Para cada región crear una base de datos.

   Apoyandonos del profesor, creamos la tabla de entidades y segmentamos la base

   */

   use covidHistorico;

	create table dbo.cat_entidades (
	  clave varchar(3),
	  entidad varchar(150),
	  abreviatura varchar(3)
	)

	insert into cat_entidades values ('01','AGUASCALIENTES','AS')
	insert into cat_entidades values ('02','BAJA CALIFORNIA','BC')
	insert into cat_entidades values ('03','BAJA CALIFORNIA SUR','BS')
	insert into cat_entidades values ('04','CAMPECHE','CC')
	insert into cat_entidades values ('05','COAHUILA DE ZARAGOZA','CL')
	insert into cat_entidades values ('06','COLIMA','CM')
	insert into cat_entidades values ('07','CHIAPAS','CS')
	insert into cat_entidades values ('08','CHIHUAHUA','CH')
	insert into cat_entidades values ('09','CIUDAD DE MÉXICO','DF')
	insert into cat_entidades values ('10','DURANGO','DG')
	insert into cat_entidades values ('11','GUANAJUATO','GT')
	insert into cat_entidades values ('12','GUERRERO','GR')
	insert into cat_entidades values ('13','HIDALGO','HG')
	insert into cat_entidades values ('14','JALISCO','JC')
	insert into cat_entidades values ('15','MÉXICO','MC')
	insert into cat_entidades values ('16','MICHOACÁN DE OCAMPO','MN')
	insert into cat_entidades values ('17','MORELOS','MS')
	insert into cat_entidades values ('18','NAYARIT','NT')
	insert into cat_entidades values ('19','NUEVO LEÓN','NL')
	insert into cat_entidades values ('20','OAXACA','OC')
	insert into cat_entidades values ('21','PUEBLA','PL')
	insert into cat_entidades values ('22','QUERÉTARO','QT')
	insert into cat_entidades values ('23','QUINTANA ROO','QR')
	insert into cat_entidades values ('24','SAN LUIS POTOSÍ','SP')
	insert into cat_entidades values ('25','SINALOA','SL')
	insert into cat_entidades values ('26','SONORA','SR')
	insert into cat_entidades values ('27','TABASCO','TC')
	insert into cat_entidades values ('28','TAMAULIPAS','TS')
	insert into cat_entidades values ('29', 'TLAXCALA','TL')
	insert into cat_entidades values ('30','VERACRUZ DE IGNACIO DE LA LLAVE','VZ')
	insert into cat_entidades values ('31','YUCATÁN','YN')
	insert into cat_entidades values ('32','ZACATECAS','ZS')
	insert into cat_entidades values ('36','ESTADOS UNIDOS MEXICANOS','EUM')
	insert into cat_entidades values ('97','NO APLICA','NA')
	insert into cat_entidades values ('98','SE IGNORA','SI')
	insert into cat_entidades values ('99','NO ESPECIFICADO','NE')


	create database region_noroeste
	GO
	use region_noroeste
	GO
	select * into datoscovid
	from covidHistorico.dbo.datoscovid 
	where entidad_res in (
						  select clave
						  from covidHistorico.dbo.cat_entidades
						  where entidad in ('Baja California','Baja California Sur','Chihuahua',
						  'Sinaloa','Sonora'))


	create database region_noreste
	GO
	use region_noreste
	GO
	select * into datoscovid
	from covidHistorico.dbo.datoscovid 
	where entidad_res in (
						  select clave
						  from covidHistorico.dbo.cat_entidades
						  where entidad in ('COAHUILA DE ZARAGOZA','Durango','Nuevo León',
						  'San Luis Potosí','Tamaulipas'))

	create database region_centro
	GO
	use region_centro
	GO
	select * into datoscovid
	from covidHistorico.dbo.datoscovid 
	where entidad_res in (
						  select clave
						  from covidHistorico.dbo.cat_entidades
						  where entidad in ('Ciudad de México','MÉXICO','Guerrero',
						  'Hidalgo','Morelos','Puebla','Tlaxcala'))


	create database region_occidente
	GO
	use region_occidente
	GO
	select * into datoscovid
	from covidHistorico.dbo.datoscovid 
	where entidad_res in (
						  select clave
						  from covidHistorico.dbo.cat_entidades
						  where entidad in ('Aguascalientes','Colima','Guanajuato',
						  'Jalisco','MICHOACÁN DE OCAMPO','Nayarit','Querétaro','Zacatecas'))


	create database region_sureste
	GO
	use region_sureste
	GO
	select * into datoscovid
	from covidHistorico.dbo.datoscovid 
	where entidad_res in (
						  select clave
						  from covidHistorico.dbo.cat_entidades
						  where entidad in ('Campeche','Chiapas','Oaxaca',
						  'Quintana Roo','Tabasco','VERACRUZ DE IGNACIO DE LA LLAVE','Yucatán'))


/*Desarrollo: Aplicando las bases de datos de regiones (CovidHistorico) resuelva las siguientes 
			   consultas en SQL Server.*/


   /*1. Listar por entidad de residencia cuantos casos confirmados / casos registrados
		por mes de los años 2020, 2021 y 2022.*/

		/* Hecho por: Alvarez Garcia Elian Alexander y Diego Vertiz Alexis */

		drop procedure if exists sp_consultapormes;
		go

		create procedure sp_consultapormes
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql1 nvarchar(1000)
			set @strSql1 = 'select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, 
			   B.total_registrados 
			from
			(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
			from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes, 
					  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				where CLASIFICACION_FINAL between 1 and 3
				group by entidad_res, mes, anio)  as A 
				inner join 
				(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
				 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes, 
						  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
			group by entidad_res, mes, anio)  as B
			on A.ENTIDAD_RES = B.ENTIDAD_RES and 
			   A.mes = B.mes and A.anio = B.anio'
	  execute sp_executesql @strSql1
	  end
	  go

	  drop table if exists #casospormes;
	  go
	  create table #casospormes (ENTIDAD_RES int,mes int,anio nvarchar(4),
								total_confirmados int,total_registrados int)

	  INSERT #casospormes								
		exec sp_consultapormes region_centro
	  INSERT #casospormes								
		exec sp_consultapormes region_noreste
	  INSERT #casospormes								
		exec sp_consultapormes region_noroeste
	  INSERT #casospormes								
		exec sp_consultapormes region_occidente
	  INSERT #casospormes								
		exec sp_consultapormes region_sureste

	
		select 
		E.entidad as 'Entidad', D.*
		from covidHistorico.dbo.cat_entidades E 
		join #casospormes D
		on D.ENTIDAD_RES = E.clave 
		order by ENTIDAD_RES, anio,mes



  /* A partir del conjunto de la consulta 1 y los datos originales:*/
   
  /* 2. Determinar en que entidad de residencia y en que mes se reportaron más casos confirmados 
		y que porcentaje representa del total de casos por entidad.
		Hecho por: Diego Vertiz Alexis*/
	

	 
	 select A.entidad, A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados,
			B.total_estado_confir, B.porcentaje
			from (
				select top (1) E.entidad, D.ENTIDAD_RES, D.mes, D.anio, D.total_confirmados
				from #casospormes D
				join covidHistorico.dbo.cat_entidades E
				on D.ENTIDAD_RES = E.clave 
				order by D.total_confirmados desc
			) as A
			inner join
			(select D.ENTIDAD_RES, 
				sum(D.total_confirmados) as total_estado_confir,
				100*(select top (1)  D.total_confirmados from #casospormes D
					order by D.total_confirmados desc)/sum(D.total_confirmados) as porcentaje
				from #casospormes D
				group by D.ENTIDAD_RES) as B
			on A.ENTIDAD_RES=B.ENTIDAD_RES


  /* 3. Determinar cuantos casos fueron atendidos en entidades distintas a la entidad de residencia.
		Hecho por Alvarez Garcia Elian Alexander*/

		drop procedure if exists sp_entidad_distinta;
		go

		create procedure sp_entidad_distinta
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql2 nvarchar(500)
			set @strSql2 = 'select count (*) as diferente_edo
							from '+@dbnombre+'.dbo.datoscovid D
							where ENTIDAD_RES != ENTIDAD_UM'
	  execute sp_executesql @strSql2
	  end
	  go

	  drop table if exists #entidaddis;
	  go
	  create table #entidaddis (diferente_edo int)

	  INSERT #entidaddis								
		exec sp_entidad_distinta region_centro
	  INSERT #entidaddis								
		exec sp_entidad_distinta region_noreste
	  INSERT #entidaddis								
		exec sp_entidad_distinta region_noroeste
	  INSERT #entidaddis								
		exec sp_entidad_distinta region_occidente
	  INSERT #entidaddis								
		exec sp_entidad_distinta region_sureste

	
		select sum(diferente_edo) as 'casos_dif_edo'
		from #entidaddis
		

  /* 4. Determinar la evolución de la pandemia (casos registrados / casos sospechosos / 
	  casos confirmados por mes) en cada una de las entidades del país. Esta información
	  permitirá identificar los picos de casos en las diferentes olas de contagio registradas.*/
		
		/*Hecho por Alvarez Garcia Elian Alexander*/

		drop procedure if exists sp_evolucionpormes;
		go

		create procedure sp_evolucionpormes
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql3 nvarchar(1500)
			set @strSql3 = 'select A.ENTIDAD_RES, A.mes, A.anio, A.total_confirmados, 
			   B.total_registrados, C.total_sospechosos
			   from
				(select T.entidad_res, T.mes, T.anio, count(*) total_confirmados
				from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes, 
						  year(fecha_ingreso) anio, CLASIFICACION_FINAL
					   from '+@dbnombre+'.dbo.datoscovid
					   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
					where CLASIFICACION_FINAL between 1 and 3
					group by entidad_res, mes, anio)  as A 
			    inner join 
				(select T.entidad_res, T.mes, T.anio, count(*) total_registrados
				 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes, 
						  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				   group by entidad_res, mes, anio)  as B
			   on A.ENTIDAD_RES = B.ENTIDAD_RES and 
			   A.mes = B.mes and A.anio = B.anio
				  inner join 
				(select T.entidad_res, T.mes, T.anio, count(*) total_sospechosos
				 from ( select id_registro, entidad_res, month(FECHA_INGRESO) mes, 
						  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				   where CLASIFICACION_FINAL = 6
				   group by entidad_res, mes, anio)  as C
				   
			 on A.ENTIDAD_RES = C.ENTIDAD_RES and 
			   A.mes = C.mes and A.anio = C.anio
			   ' 
	  execute sp_executesql @strSql3
	  end
	  go

	  drop table if exists #ev_pormes;
	  go
	  create table #ev_pormes (ENTIDAD_RES int, mes int, anio nvarchar(4),
								total_confirmados int,total_registrados int,total_sospechosos int)

	  INSERT #ev_pormes								
		exec sp_evolucionpormes region_centro
	  INSERT #ev_pormes								
		exec sp_evolucionpormes region_noreste
	  INSERT #ev_pormes								
		exec sp_evolucionpormes region_noroeste
	  INSERT #ev_pormes								
		exec sp_evolucionpormes region_occidente
	  INSERT #ev_pormes								
		exec sp_evolucionpormes region_sureste

	
		select 
		E.entidad as 'Entidad', D.*
		from covidHistorico.dbo.cat_entidades E 
		join #ev_pormes D
		on D.ENTIDAD_RES = E.clave 
		order by ENTIDAD_RES, anio,mes




  /* 5. Determinar cuantos registros se repiten en la base de datos, considerando las 
		siguientes columnas: [ENTIDAD_UM],[SEXO],[ENTIDAD_NAC],[ENTIDAD_RES]
      ,[MUNICIPIO_RES],[EDAD],[NACIONALIDAD],[HABLA_LENGUA_INDIG],[INDIGENA]
	  ,[DIABETES],[EPOC],[ASMA],[INMUSUPR],[HIPERTENSION],[OTRA_COM],[CARDIOVASCULAR]
	  ,[OBESIDAD],[RENAL_CRONICA],[TABAQUISMO],[OTRO_CASO],[MIGRANTE]
	  ,[PAIS_NACIONALIDAD],[PAIS_ORIGEN]     

	  Ordenar los datos por entidad de residencia*/

	  /*HECHO POR: Gallardo Cervantes Mario*/

	  -- para cada entidad de residencia se muestra el conteo de las columnas duplicadas
	  select ENTIDAD_RES, count(*) as Duplicados from covidHistorico.dbo.datoscovid
	  -- agrupa las columnas en las cuales se desean saber registros duplicados
	  group by ENTIDAD_UM,SEXO,ENTIDAD_NAC,ENTIDAD_RES
      ,MUNICIPIO_RES,EDAD,NACIONALIDAD,HABLA_LENGUA_INDIG,INDIGENA
	  ,DIABETES,EPOC,ASMA,INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR
	  ,OBESIDAD,RENAL_CRONICA,TABAQUISMO,OTRO_CASO,MIGRANTE
	  ,PAIS_NACIONALIDAD,PAIS_ORIGEN
	  -- si el conteo es mayor que 1 significa que hay registros duplicados
	  having count(*) > 1
	  -- se ordenan los datos por entidad de residencia
	  order by ENTIDAD_RES;
	  

  /* 6. Listar todas las columnas de los registros duplicados obtenidos en la consulta 5. 
		Para esta consulta aplique el concepto de resta de conjuntos o diferencia de 
	    álgebra relacional. Ordenar los resultados por entidad de residencia.
		tomar el conjunto de la 5 y restar el conjunto original
		*/
		/*HECHO POR: Gallardo Cervantes Mario*/

	  (select ENTIDAD_RES, count(*) as Duplicados from covidHistorico.dbo.datoscovid
	  group by ENTIDAD_UM,SEXO,ENTIDAD_NAC,ENTIDAD_RES
      ,MUNICIPIO_RES,EDAD,NACIONALIDAD,HABLA_LENGUA_INDIG,INDIGENA
	  ,DIABETES,EPOC,ASMA,INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR
	  ,OBESIDAD,RENAL_CRONICA,TABAQUISMO,OTRO_CASO,MIGRANTE
	  ,PAIS_NACIONALIDAD,PAIS_ORIGEN
	  having count(*) > 1)
	  intersect
	  (select ENTIDAD_RES, count(*) as Duplicados from covidHistorico.dbo.datoscovid
	  group by ENTIDAD_UM,SEXO,ENTIDAD_NAC,ENTIDAD_RES
      ,MUNICIPIO_RES,EDAD,NACIONALIDAD,HABLA_LENGUA_INDIG,INDIGENA
	  ,DIABETES,EPOC,ASMA,INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR
	  ,OBESIDAD,RENAL_CRONICA,TABAQUISMO,OTRO_CASO,MIGRANTE
	  ,PAIS_NACIONALIDAD,PAIS_ORIGEN);

  /*   7. Determinar las 5 entidades con el mayor número de fallecidos 
      por año, con casos de neumonía (=1) y caso no confirmado de Covid (resulatdo_final between 4 and 7).  
	  */
	  /*HECHO POR: Gallardo Cervantes Mario*/

	 	  drop procedure if exists sp_top_fallecidos;
		go

		create procedure sp_top_fallecidos
			@dbnombre SYSNAME
			
		AS
		BEGIN
		SET NOCOUNT ON;
		declare @ResultsIds nvarchar(250) = '9999-99-99'
		DECLARE @strSql10 nvarchar(1000)
		set @strSql10 = 'select A.entidad_res, A.anio, A.total_confirmados
			from
			(select T.entidad_res, T.anio, count(*) total_confirmados
			from ( select entidad_res, NEUMONIA, FECHA_DEF,
					  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				where CLASIFICACION_FINAL between 4 and 7
					and NEUMONIA=1 and FECHA_DEF != cast('+'9999-99-99'+' as nvarchar)  
				group by entidad_res, anio)  as A'

	  execute sp_executesql @strSql10
	  end
	  go

	  drop table if exists #top_fallecidos;
	  go
	  create table #top_fallecidos (ENTIDAD_RES int,anio int, total_no_confirmados int)
									 
	  INSERT #top_fallecidos								
		exec sp_top_fallecidos region_centro
	  INSERT #top_fallecidos							
		exec sp_top_fallecidos region_noreste
	  INSERT #top_fallecidos								
		exec sp_top_fallecidos region_noroeste
	  INSERT #top_fallecidos								
		exec sp_top_fallecidos region_occidente
	  INSERT #top_fallecidos							
		exec sp_top_fallecidos region_sureste

		SELECT  *
		FROM    (SELECT *,
						ROW_NUMBER() OVER (PARTITION BY anio ORDER BY total_no_confirmados DESC) orden_por_anio
				 FROM   #top_fallecidos
				) t
		WHERE   orden_por_anio between 1 and 5


  /* 8. Determinar que entidades presentan comorbilidad sin obesidad
      y sin hipertensión.*/
	  
  /*HECHO POR: Diego Vertiz Alexis*/
	  drop procedure if exists sp_comorbilidad;
		go

		create procedure sp_comorbilidad
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql8 nvarchar(1500)
			set @strSql8 = 'select ID_REGISTRO, ENTIDAD_RES, TIPO_PACIENTE, 
								   DIABETES, HIPERTENSION, OBESIDAD, CARDIOVASCULAR, 
								   INMUSUPR, EPOC, ASMA, RENAL_CRONICA, TABAQUISMO, 
								   CLASIFICACION_FINAL, INTUBADO, UCI 
							from '+@dbnombre+'.dbo.datoscovid A
							where exists (select *
										  from (select id_registro,
														 IIF( IIF(EPOC = 1,1,0)+
														   IIF(ASMA = 1,1,0)+
														   IIF(INMUSUPR = 1,1,0)+
														   IIF(CARDIOVASCULAR = 1,1,0) +
														   IIF(TABAQUISMO = 1,1,0) +
														   IIF(OBESIDAD = 1,1,0) +
														   IIF(RENAL_CRONICA = 1,1,0) +
														   IIF(OTRA_COM = 1,1,0) >= 2, 1, null) as noEnfermedades
												from '+@dbnombre+'.dbo.datoscovid ) as T
										   where A.ID_REGISTRO = T.ID_REGISTRO and noEnfermedades is not null
										   and DIABETES = 2 and HIPERTENSION = 2)' 
	  execute sp_executesql @strSql8
	  end
	  go

	  drop table if exists #comorbilidad;
	  go
	  create table #comorbilidad (ID_REGISTRO nvarchar(15), ENTIDAD_RES nvarchar(15), 
								  TIPO_PACIENTE int, DIABETES int, HIPERTENSION int,
								  OBESIDAD int, CARDIOVASCULAR int, INMUSUPR int, EPOC int, 
								  ASMA int, RENAL_CRONICA int, TABAQUISMO int, 
								  CLASIFICACION_FINAL int, INTUBADO int, UCI nvarchar(50))

	  INSERT #comorbilidad								
		exec sp_comorbilidad region_centro
	  INSERT #comorbilidad								
		exec sp_comorbilidad region_noreste
	  INSERT #comorbilidad								
		exec sp_comorbilidad region_noroeste
	  INSERT #comorbilidad								
		exec sp_comorbilidad region_occidente
	  INSERT #comorbilidad								
		exec sp_comorbilidad region_sureste

	
		select ENTIDAD_RES, COUNT(*) as casos_sin_deh from #comorbilidad
		group by ENTIDAD_RES
		order by ENTIDAD_RES
	

		

  /* 9. Determinar cuantos casos confirmados por genero y en el rango de los
      20 a los 39 y de los 40 a 59 se registraron en 2020, 2021 y 2022 (hasta 
	  la fecha en que se tienen registros en la base de datos).*/

	    /*HECHO POR: Diego Vertiz Alexis*/

	  drop procedure if exists sp_genero_edad;
		go

		create procedure sp_genero_edad
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql9 nvarchar(1000)
			set @strSql9 = 'select A.anio, A.total_confirmados, A.SEXO, '+'20'+' as RANGO_INI, '+'39'+' as RANGO_FIN
				from
			(select T.anio, T.SEXO, count(*) total_confirmados
			from ( select EDAD, SEXO, 
					  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				where CLASIFICACION_FINAL between 1 and 3
						and EDAD between 20 and 39
				group by anio, SEXO)  as A
				
				union

				select A.anio, A.total_confirmados, A.SEXO, '+'40'+' as RANGO_INI,  '+'59'+' as RANGO_FIN
				from
			(select T.anio, T.SEXO, count(*) total_confirmados
			from ( select EDAD, SEXO, 
					  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				where CLASIFICACION_FINAL between 1 and 3
						and EDAD between 40 and 59
				group by anio, SEXO)  as A'
				
	  execute sp_executesql @strSql9
	  end
	  go

	  drop table if exists #edad_genero;
	  go
	  create table #edad_genero (anio int, total_confirmados int, sexo int,
									rango_ini int, rango_fin int)
									 
	  INSERT #edad_genero								
		exec sp_genero_edad region_centro
	  INSERT #edad_genero								
		exec sp_genero_edad region_noreste
	  INSERT #edad_genero								
		exec sp_genero_edad region_noroeste
	  INSERT #edad_genero								
		exec sp_genero_edad region_occidente
	  INSERT #edad_genero								
		exec sp_genero_edad region_sureste

		select anio, sexo, rango_ini, rango_fin,sum(total_confirmados) total_confirmados
		from #edad_genero
		group by anio, sexo, rango_ini, rango_fin





  /* 10. Determinar por entidad en que año de los registrados en la base de 
		 datos, se presentaron más casos en niños menos a 12 años.*/

		   /*HECHO POR: Diego Vertiz Alexis*/
		 drop procedure if exists sp_menores_doce;
		go

		create procedure sp_menores_doce
			@dbnombre SYSNAME
		AS
		BEGIN
		SET NOCOUNT ON;
		DECLARE @strSql10 nvarchar(1000)
		set @strSql10 = 'select A.entidad_res, A.anio, A.total_confirmados
			from
			(select T.entidad_res, T.anio, count(*) total_confirmados
			from ( select entidad_res, EDAD,
					  year(fecha_ingreso) anio, CLASIFICACION_FINAL
				   from '+@dbnombre+'.dbo.datoscovid
				   where year(fecha_ingreso) between '+'2020'+' and '+'2022'+') as T
				where CLASIFICACION_FINAL between 1 and 3
					and EDAD between 0 and 12
				group by entidad_res, anio)  as A'
				
				
	  execute sp_executesql @strSql10
	  end
	  go

	  drop table if exists #menores_doce;
	  go
	  create table #menores_doce (ENTIDAD_RES int,  ANIO int, total_confirmados int)
									 
	  INSERT #menores_doce								
		exec sp_menores_doce region_centro
	  INSERT #menores_doce								
		exec sp_menores_doce region_noreste
	  INSERT #menores_doce								
		exec sp_menores_doce region_noroeste
	  INSERT #menores_doce								
		exec sp_menores_doce region_occidente
	  INSERT #menores_doce								
		exec sp_menores_doce region_sureste

		select B.clave, B.entidad as 'Entidad', A.ANIO, A.total_confirmados
		from (select d.*
			from #menores_doce d
			inner join 
				(select ENTIDAD_RES, MAX(total_confirmados) as TotalConfirmados
				from #menores_doce
				group by ENTIDAD_RES)  T
			on d.ENTIDAD_RES = 	T.ENTIDAD_RES
			and d.total_confirmados = T.TotalConfirmados) A
		left join 
			(select 
				E.entidad as 'Entidad', E.clave, d.total_confirmados
				from covidHistorico.dbo.cat_entidades E 
				join #menores_doce D
				on D.ENTIDAD_RES = E.clave) B
		on B.clave = A.ENTIDAD_RES	AND B.total_confirmados = A.total_confirmados	
		order by clave



  /*CONCLUSIONES

  La practica sirve para dar una introducción a las bases de datos distribuidos, 
  ya que en cursos pasados, generalmente solo se trabajaba sobre una sola base 
  de datos.

  En cuanto a las consultas fueron algo dificiles de manipular, debido a que el 
  nivel que se pide es más complejo al que estabamos acostumbrados a implementar.

  La practica se trabajo implementando principalmente procedimientos almacenados
  y SQL dinamico, las cuales consideramos, son herramientas muy importantes cuando
  queremos hacer consultas u operaciones en bases de datos
					
					
*/
