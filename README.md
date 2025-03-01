# Payment API

Este documento contém uma checklist dos requisitos e tarefas para o desenvolvimento da API de Pagamentos.

## 1. Requisitos

- [ ] Cálculo de retenção por parcelas
- [ ] Liquidação de recebíveis
- [ ] Transações parceladas
- [x] Controle de status das transações
- [x] Controle de status das parcelas

- [ ] Realizar transações de pagamento e dividir os recebíveis de uma transação em várias parcelas
- [x] Retorno indicando se a transação foi aprovada ou reprovada
- [ ] Gateway Fake (parcelas ímpares são reprovadas, e parcelas pares são aprovadas)
- [x] Manter a flexibilidade para integrar com gateways reais no futuro
- [ ] O valor de retenção será de 0,99% por parcela adicionada
- [ ] Utilizar processamento em background para a criação dos recebíveis utilizando a ferramenta Sidekiq

## 2. Tabela de Transações

- [x] Criar uma tabela para armazenar as transações **(PaymentTransactions)**
  - [ ] Implementar método para calcular valor de repasse da transação
  - [ ] Implementar método para calcular valor de retenção da transação

## 3. Tabela de Taxas de Parcelamento

- [x] Implementar uma tabela para armazenar as taxas de parcelamento **(InstallmentFees)**

## 4. Recebíveis

- [x] Implementar uma tabela para armazenar os recebiveis **(Receivables)**
  - [ ] Implementar método para calcular valor de repasse da parcela
  - [ ] Implementar método para calcular valor de retenção da parcela

Cada parcela gerada deverá ter as seguintes informações:
- [x] **schedule_date** Data de agendamento da parcela, que será a data da transação somada ao número de meses correspondente ao número da parcela
- [x] **liquidation_date** Data de pagamento, inicialmente nula e preenchida durante o processo de liquidação
- [x] **status** Status inicialmente "pendente", alterado para "liquidado" após a liquidação
- [x] **amount_to_settle** Valor a ser liquidado
- [x] **amount_settled** Inicialmente 0, será preenchido após a liquidação

## 5. Liquidação de Recebíveis via Cron

- [ ] Implementar uma funcionalidade acionada por um cron job que liquida os recebíveis, com base na data de agendamento:
  - [ ] Se a data de agendamento for igual à data atual e o status da parcela for "pendente", a parcela será marcada como "liquidado"
  - [ ] A `liquidation_date` será preenchida com a data atual
  - [ ] O `amount_settled` será igual ao `amount_to_settle`

## 6. Listagem das Transações

- [ ] Implementar um endpoint para listar transações com os seguintes filtros:
  - [ ] Filtro por intervalo de datas (se não informado, considerar os últimos 30 dias)
  - [ ] Paginação dos resultados

## 7. Listagem de Recebíveis

- [ ] Implementar um endpoint para listar todos os recebíveis, com possibilidade de filtro por transações aprovadas

## Tecnologias e Ferramentas Requeridas

- [x] Ruby on Rails: Framework principal para a construção da API
- [ ] Sidekiq: Para processamento assíncrono da liquidação de recebíveis
- [x] RSpec: Para testes automatizados
- [x] Banco de Dados (PostgreSQL/MySQL): Para armazenar as tabelas de transações, taxas e recebíveis
- [x] Docker: Para facilitar a execução e a entrega da aplicação via containers

## Instruções para o Candidato

- [x] O código deve ser entregue em um repositório Git público
- [x] Todos os testes devem ser escritos utilizando RSpec
- [ ] A aplicação deve estar configurada para rodar com Sidekiq para processamento assíncrono de recebíveis
- [ ] O candidato deve garantir que todos os requisitos sejam atendidos e que a API funcione conforme o esperado
- [ ] O código deve ser bem estruturado e legível
- [ ] O código deve ter boa cobertura de testes
