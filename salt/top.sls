base:
  'G@consul:master or G@consul:agent':
    - match: compound
    - consul

  'G@docker:master or G@docker:worker':
    - match: compound
    - docker

  'G@docker:master or G@docker:worker':
    - match: compound
    - roles.docker-swarm

  'G@docker:worker':
    - match: compound
    - roles.docker-registrator
