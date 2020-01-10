create table desenvolvedores
(
id_dev int identity not null,
nome_dev varchar (100) not null,
dev_localizacao varchar(2) default ('SP'),------default
salario_dev int not null default(1000)--------default
)

create table gerentes
(
id_gerente int identity not null,
nome_gerente varchar(100) not null,
dpto_gerente varchar (100) not null,
empresa_gerente varchar (100) default ('loja pontoA')
)
insert into gerentes values('Alberto Souza','front-end loja pontoA', 'loja pontoA')
insert into gerentes values('Gisele Martins','back-end loja pontoA', 'loja pontoA')

insert into desenvolvedores values('Lucas Montano','RS', 10000)
insert into desenvolvedores values('Felipe Deschamps','SC', 9500)
insert into desenvolvedores values('Diego Monteiro','SC', 5600)
insert into desenvolvedores values('Robson Caetano','SP', 12000)
insert into desenvolvedores values('Gabriel Froes','RJ', 13500)
-- REGRAS--
create rule rl_salario as @dev_salario >1000
create rule rl_nome as @nome_dev != ('ze')
create rule rl_nome2 as @nome_dev != ('undefined')
create rule rl_salario2 as @salario_dev != 0

exec sp_bindrule rl_salario, 'desenvolvedores.salario_dev'
exec sp_bindrule rl_nome, 'desenvolvedores.nome_dev'
exec sp_bindrule rl_nome2, 'desenvolvedores.nome_dev'
exec sp_bindrule rl_salario2, 'desenvolvedores.salario_dev'

----VIEWS------

create view total as
  select id_dev as id, count(*) as qtd
    from desenvolvedores group by id_dev        -------AQUI TEMOS UM GROUP BY

	select * from total

create view ms_devs as
  select avg(salario_dev) AS MediaSalarios from desenvolvedores group by salario_dev ----AQUI TEMOS MAIS UM GROUP BY 

  select * from ms_devs

-----TOTAL DE GROUP BY: 2


---------TRIGGERES-----------
create table dev_log (
            id int not null identity,
            tipo varchar(10) not null,
            dt datetime not null,
            quem varchar(30) not null
			)


create trigger trigger_deletar on desenvolvedores
    for DELETE
    as
    begin
        insert into dev_log values('Deletando',getdate(),CURRENT_USER)

    end

create trigger trigger_inserir on desenvolvedores
    for INSERT
    as
    begin
        insert into dev_log values('Inserindo',getdate(),CURRENT_USER)

    end

select * from dev_log

------STORED PROCEDURES---------
create procedure Busca
@idDesenvolvedor varchar (20) as
select id_dev, nome_dev 
from desenvolvedores
where id_dev = @idDesenvolvedor 

	
execute Busca '1'


create procedure BuscaGerente
@idGerente varchar(2) as 
	select id_gerente, nome_gerente, id_dev, nome_dev from gerentes g, desenvolvedores d  where d.id_dev = @idGerente
	

execute BuscaGerente '2'

create procedure AtualizaDev @idDev varchar (2) as
UPDATE desenvolvedores SET salario_dev = 20000 WHERE id_dev = @idDev

execute AtualizaDev '3'

select * from desenvolvedores


------------CURSORES---------------

---1
create proc sp_Atualizando
as
begin
declare @idDesenvolvedor int,
        @nomeDesenvolvedor varchar(30)

declare MeuCursor CURSOR FOR
  select id_dev, nome_dev  from desenvolvedores

 open MeuCursor

 fetch next from MeuCursor into @idDesenvolvedor,@nomeDesenvolvedor

 while @@FETCH_STATUS = 0
 begin
     update desenvolvedores set nome_dev = 
       rtrim(ltrim(@nomeDesenvolvedor)) + ' ' 

         where id_dev = @idDesenvolvedor

     fetch next from MeuCursor into   @idDesenvolvedor,
                                    @nomeDesenvolvedor

 end

 close MeuCursor

 deallocate MeuCursor 
end

---2
create proc sp_AlterarGerente
as
begin
declare @idGerente int,
        @nomeGerente varchar(30)

declare CursorGerentes CURSOR FOR
  select id_gerente, nome_gerente  from gerentes
  open CursorGerentes

 fetch next from CursorGerentes into @idgerente,@nomeGerente

 while @@FETCH_STATUS = 0
 begin
     update gerentes set nome_gerente = 
       rtrim(ltrim(@nomeGerente)) + ' ' 

         where id_gerente = @idGerente

     fetch next from CursorGerentes into   @idGerente,
                                    @nomeGerente

 end

 close CursorGerentes

 deallocate CursorGerentes
end




