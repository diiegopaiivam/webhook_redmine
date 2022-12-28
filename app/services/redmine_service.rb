class RedmineService
    BASE_URL = "http://129.146.125.163:3001/"
    API_KEY = Rails.application.credentials[:default][:redmine_api][:password]

    require "uri"
    require "json"
    require "net/http"


    def self.init_project(params)
        @projeto = create_project(params)
        bind_members(@projeto["project"]["id"])
        create_version(@projeto["project"]["id"])
        create_issue(@projeto["project"]["id"])
        create_wiki(@projeto["project"]["id"], @projeto["project"]["name"])
    end 


    private 

    def self.create_project(params)

        url = URI("#{BASE_URL}projects.json")

        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Post.new(url)
        request["X-Redmine-API-Key"] = API_KEY
        request["Content-Type"] = "application/json"
        request.body = JSON.dump({
          "project": {
            "name": params["name"],
            "identifier": params["identifier"],
            "description": params["description"],
            "is_public": params["is_public"],
            "inherit_members": params["inherit_members"],
            "tracker_ids": [
              1
            ],
            "enabled_module_names": [
              "issue_tracking",
              "wiki",
              "issue"
            ]
          }
        })
        
        response = http.request(request)
        JSON.parse(response.body)
    end 

    def self.bind_members(id)
        url = URI("#{BASE_URL}projects/#{id}/memberships.json")

        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Post.new(url)
        request["X-Redmine-API-Key"] = API_KEY
        request["Content-Type"] = "application/json"

        request.body = JSON.dump({
            "membership":
            {
              "user_id": 7,
              "role_ids": [ 3 ]
            }
          })

          response = http.request(request)
          puts response.read_body
    end 


    def self.create_version(id)
        url = URI("#{BASE_URL}projects/#{id}/versions.json")

        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Post.new(url)
        request["X-Redmine-API-Key"] = API_KEY
        request["Content-Type"] = "application/json"

        request.body = JSON.dump({
            "version": {
                "name":"product backlog",
                "description":"DESCRIÇÃO DE PROJETO QUATRO PARA TESTE",
                "wiki_page_title":"WIKI PAGE TESTE PROJETO 4"
            }
          })

          response = http.request(request)
    end 

    def self.create_issue(id)

        url = URI("#{BASE_URL}projects/#{id}/issues.json")

        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Post.new(url)
        request["X-Redmine-API-Key"] = API_KEY
        request["Content-Type"] = "application/json"

        request.body = JSON.dump({
            "issue": {
                "project_id": "#{id}",
                "subject": "TAREFA DE VISÃO DE TESTE",
                "priority_id": 4,
                "status_id": 1,
                "tracker_id":1
              }
          })

          response = http.request(request)
    end 

    def self.create_wiki(id, name)
        url = URI("#{BASE_URL}projects/#{id}/wiki/index.xml")

        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Put.new(url)
        request["X-Redmine-API-Key"] = API_KEY
        request["Content-Type"] = "application/xml"
        request.body = "<?xml version=\"1.0\"?>\r\n<wiki_page>\r\n  <title>#{name}</title>\r\n  <parent title=\"Installation_Guide\"/>\r\n    <text>h1. Projeto {project_name} \r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/integration_instructions/v9/24px.svg!  [[produto| Informações sobre o produto]]\r\n> Informações ligadas ao produto que está sendo desenvolvido\r\n>\r\n> * [[visao|Visão]] : Informações sobre a visão do produto final\r\n> * [[storymap|Mapa de estórias]] : Um mapeamento das estórias que compõem a visão do produto\r\n> * [[backlog| Backlog do produto]] : Informações sobre o backlog do produto\r\n> * [[projeto| Informações de projeto]] : Informações sobre o design e projeto do produto.\r\n> * [[docs|Documentação]] : Documentações relevantes do projeto como materials de referência, manuais, FAQs, atas de reunião, etc...\r\n> * [[relatorios|Relatórios]] : Relatórios sobre o produto como matriz de rastreabilidade, [[dependencymap|dependencias]], [[storymap|Mapa de estórias]], etc.\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/timeline/v11/24px.svg!  [[processo| Informações sobre o Processo de desenvolvimento]] \r\n> Informações ligadas ao processo de desenvolvimento do produto\r\n>\r\n> * [[backlog| Backlog]] : Informações sobre o backlog do produto\r\n> * [[sprints| Sprints]] : Informações sobre as sprints do projeto, as cerêmonias realizadas (daily scrum, retrospectivas, revisão da sprint), kanbans e gráficos de burn down.\r\n> * [[metricas|Métricas]] : Informações sobre as métricas do processo (Lead time, cycle time, throughput, qualidade (testes), homologações, SPC, CFD)\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/business/v10/24px.svg!  [[institucional| Informações institucionais]] \r\n> Informações relacionadas a intituição ou ao projeto.\r\n>\r\n> * [[cmdb| Informações cadastrais]] : Informações cadastrais do produto como área do sistema, portifólio, etc...\r\n> * [[steakholders| Stakeholders]] : Informações sobre os steakholders do projeto/produto, contatos, etc...\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/build/v10/24px.svg! [[operacao| Informações operacionais]] \r\n> Informações ligadas as questões operacionais do produto\r\n>\r\n> * [[ambientes| Ambientes]] : Informações sobre o ambiente de TIC do produto, servidores utilizados, etc...\r\n> * [[devopsPage| DevOps]] : Informações do DevOps\r\n> * [[gddPage|Gerência de Demandas]] : Informações relativas a gestão das demandas\r\n    </text>\r\n    \r\n</wiki_page>"
        
        response = http.request(request)
    end 

end 