base:
  'consul:agent':
    - match: grain
    - consul.node

  'consul:master':
    - match: grain
    - consul.server
  
  'G@docker:master or G@docker:worker':
    - match: compound
    - docker