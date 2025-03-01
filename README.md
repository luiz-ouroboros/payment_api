# Payment API

Este documento contém uma checklist dos requisitos e tarefas para o desenvolvimento da API de Pagamentos.

## Checklist de Funcionalidades

- [ ] Cálculo de retenção por parcelas
- [ ] Liquidação de recebíveis
- [ ] Transações parceladas
- [ ] Controle de status das transações
- [ ] Controle de status das parcelas

- [ ] Realizar transações de pagamento e dividir os recebíveis de uma transação em várias parcelas
- [x] Retorno indicando se a transação foi aprovada ou reprovada
- [ ] Gateway Fake (parcelas ímpares são reprovadas, e parcelas pares são aprovadas)
- [x] Manter a flexibilidade para integrar com gateways reais no futuro
- [ ] O valor de retenção será de 0,99% por parcela adicionada
- [ ] Utilizar processamento em background para a criação dos recebíveis utilizando a ferramenta Sidekiq
- [x] Criar uma tabela para armazenar as transações
- [ ] Implementar uma tabela para armazenar as taxas de parcelamento

- [ ] Implementar método para calcular valor de repasse da transação
- [ ] Implementar método para calcular valor de retenção da transação
- [ ] Implementar método para calcular valor de repasse da parcela
- [ ] Implementar método para calcular valor de retenção da parcela

- [ ] Data de agendamento da parcela, que será a data da transação somada ao número de meses correspondente ao número da parcela
- [ ] Data de pagamento, inicialmente nula e preenchida durante o processo de liquidação
- [ ] Status inicialmente "pendente", alterado para "liquidado" após a liquidação

- [ ] Implementar uma funcionalidade acionada por um cron job que liquida os recebíveis, com base na data de agendamento:
  - [ ] Se a data de agendamento for igual à data atual e o status da parcela for "pendente", a parcela será marcada como "liquidado"
  - [ ] A `liquidation_date` será preenchida com a data atual
  - [ ] O `amount_settled` será igual ao `amount_to_settle`

- [ ] Implementar um endpoint para listar transações com os seguintes filtros:
  - [ ] Filtro por intervalo de datas (se não informado, considerar os últimos 30 dias)
  - [ ] Paginação dos resultados

- [ ] Implementar um endpoint para listar todos os recebíveis, com possibilidade de filtro por transações aprovadas

## Outros Requisitos

- [x] O código deve ser entregue em um repositório Git público
- [x] Todos os testes devem ser escritos utilizando RSpec
- [ ] A aplicação deve estar configurada para rodar com Sidekiq para processamento assíncrono de recebíveis
- [ ] O candidato deve garantir que todos os requisitos sejam atendidos e que a API funcione conforme o esperado
- [ ] O código deve ser bem estruturado e legível
- [ ] O código deve ter boa cobertura de testes
