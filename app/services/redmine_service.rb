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
                "description":"DESCRI????O DE PROJETO QUATRO PARA TESTE",
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
                "subject": "TAREFA DE VIS??O DE TESTE",
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
        request.body = "<?xml version=\"1.0\"?>\r\n<wiki_page>\r\n  <title>#{name}</title>\r\n  <parent title=\"Installation_Guide\"/>\r\n    <text>h1. Projeto {project_name} \r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/integration_instructions/v9/24px.svg!  [[produto| Informa????es sobre o produto]]\r\n> Informa????es ligadas ao produto que est?? sendo desenvolvido\r\n>\r\n> * [[visao|Vis??o]] : Informa????es sobre a vis??o do produto final\r\n> * [[storymap|Mapa de est??rias]] : Um mapeamento das est??rias que comp??em a vis??o do produto\r\n> * [[backlog| Backlog do produto]] : Informa????es sobre o backlog do produto\r\n> * [[projeto| Informa????es de projeto]] : Informa????es sobre o design e projeto do produto.\r\n> * [[docs|Documenta????o]] : Documenta????es relevantes do projeto como materials de refer??ncia, manuais, FAQs, atas de reuni??o, etc...\r\n> * [[relatorios|Relat??rios]] : Relat??rios sobre o produto como matriz de rastreabilidade, [[dependencymap|dependencias]], [[storymap|Mapa de est??rias]], etc.\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/timeline/v11/24px.svg!  [[processo| Informa????es sobre o Processo de desenvolvimento]] \r\n> Informa????es ligadas ao processo de desenvolvimento do produto\r\n>\r\n> * [[backlog| Backlog]] : Informa????es sobre o backlog do produto\r\n> * [[sprints| Sprints]] : Informa????es sobre as sprints do projeto, as cer??monias realizadas (daily scrum, retrospectivas, revis??o da sprint), kanbans e gr??ficos de burn down.\r\n> * [[metricas|M??tricas]] : Informa????es sobre as m??tricas do processo (Lead time, cycle time, throughput, qualidade (testes), homologa????es, SPC, CFD)\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/business/v10/24px.svg!  [[institucional| Informa????es institucionais]] \r\n> Informa????es relacionadas a intitui????o ou ao projeto.\r\n>\r\n> * [[cmdb| Informa????es cadastrais]] : Informa????es cadastrais do produto como ??rea do sistema, portif??lio, etc...\r\n> * [[steakholders| Stakeholders]] : Informa????es sobre os steakholders do projeto/produto, contatos, etc...\r\n\r\n> !https://fonts.gstatic.com/s/i/materialiconsoutlined/build/v10/24px.svg! [[operacao| Informa????es operacionais]] \r\n> Informa????es ligadas as quest??es operacionais do produto\r\n>\r\n> * [[ambientes| Ambientes]] : Informa????es sobre o ambiente de TIC do produto, servidores utilizados, etc...\r\n> * [[devopsPage| DevOps]] : Informa????es do DevOps\r\n> * [[gddPage|Ger??ncia de Demandas]] : Informa????es relativas a gest??o das demandas\r\n    </text>\r\n    \r\n</wiki_page>"
        
        response = http.request(request)
    end 

end 