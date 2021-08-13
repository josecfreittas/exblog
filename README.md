# Sobre o projeto

**ExBlog** é um projeto fictício que provê uma API REST onde é possível fazer a criação de usuários e blogposts.

## Tecnologias

* [Elixir](https://elixir-lang.org)
* [Phoenix framework](https://phoenixframework.org)
* [PostgreSQL](https://www.postgresql.org)

# Setup

## Bancos de dados

Para bancos de dados (desenvolvimento e testes), foi adicionada uma configuração para [Docker Compose](https://docs.docker.com/compose/install/), onde é possível iniciar as instâncias necessárias a partir do comando `docker-compose up -d`

## Elixir e Phoenix

O projeto foi desenvolvido e testado utilizando o [Erlang/OTP 24.0](https://www.erlang.org/downloads/24.0) e o [Elixir 1.12](https://elixir-lang.org/blog/2021/05/19/elixir-v1-12-0-released/). Se você usa o gerenciador de pacotes e versões [asdf](https://github.com/asdf-vm/asdf), é possível instalar as versões recomendadas de cada pacote através do comando `asdf install` no diretório raiz do projeto (onde se encontra o arquivo `.tool-versions`).

Será preciso fazer a instalação do Phoenix Framework para que o projeto possa ser executado. O passo a passo de como fazer a instalação pode ser encontrado [aqui](https://hexdocs.pm/phoenix/installation.html).

## Configurações do projeto

No diretório `config/` será possível encontrar os arquivos `dev.exs` e `test.exs`, cada um contem as principais configurações para que o projeto possa ser executado em ambiente de desenvolvimento e de testes automáticos, respectivamente.
Esses arquivos já estão inicialmente configurados para que o projeto rode corretamente em conjunto com a execução dos bancos de dados através da configuração de Docker Composer que acompanha o projeto.

## Executando

Considerando uma configuração correta do ambiente, o projeto já poderá ser executado.

Mas antes, para fazer configuração e migração do banco de dados, é preciso executar o comando `mix ecto.setup`. Após isso, com o comando `mix phx.server` o servidor já será inicializado.

## Testes automatizados

O projeto vem com uma suíte de testes unitários e de integração. Para executar esses testes basta utilizar o comando `mix test`.

## Testando a API

O projeto acompanha um arquivo chamado `requests.http`. Esse arquivo contem a descrição de todas as endpoints que o projeto comporta, desde o fluxo de criação de contas e login, até criação, listagem e edição de postagens. É possível fazer requisições HTTP para as endpoints descritas utilizando à extensão [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) para o editor [VSCode](https://code.visualstudio.com).

Se você preferir utilizar o [Postman](https://www.postman.com) ou o [Insomnia](https://insomnia.rest), você pode utilizar o arquivo `postman_collection.json` que também é disponibilizado no projeto.

O token recebido pela endpoint `/users/login` deverá ser ser enviado via header para toda requisição que necessite de autenticação:  
> Authorization: Bearer `token`
