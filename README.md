# Payment API

Este documento contém uma checklist dos requisitos e tarefas para o desenvolvimento da API de Pagamentos.

## Banco de Dados

![ERD](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/public/db_erd.png)

## 1. Requisitos

- [x] [Cálculo de retenção por parcelas](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivable.rb#L20)
- [x] [Liquidação de recebíveis](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/config/initializers/sidekiq_cron.rb#L3)
- [x] [Transações parceladas](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivables/create_by_payment_transaction.rb#L1)
- [x] [Controle de status das transações](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transaction.rb#L18)
- [x] [Controle de status das parcelas](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivable.rb#L15)

- [x] [Realizar transações de pagamento](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transactions/create.rb#L12) e [dividir os recebíveis de uma transação em várias parcelas](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivables/create_by_payment_transaction.rb#L1)
- [x] [Retorno indicando se a transação foi aprovada ou reprovada](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/gateways/fake_gateway/creation_validation.rb#L5)
- [x] [Gateway Fake (parcelas ímpares são reprovadas, e parcelas pares são aprovadas)](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/gateways/fake_gateway/creation_validation.rb#L5)
- [x] [Manter a flexibilidade para integrar com gateways reais no futuro](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/gateways.rb#L2)
- [x] [O valor de retenção será de 0,99% por parcela adicionada](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/installment_fee.rb#L7)
- [x] [Utilizar processamento em background para a criação dos recebíveis utilizando a ferramenta Sidekiq](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transactions/create.rb#L49)

## 2. Tabela de Transações

- [x] [Criar uma tabela para armazenar as transações **(PaymentTransactions)**](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/db/migrate/20250227223819_create_payment_transactions.rb) 
  - [x] [Implementar método para calcular valor de repasse da transação](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transaction.rb#L53)
  - [x] [Implementar método para calcular valor de retenção da transação](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transaction.rb#L42)

## 3. Tabela de Taxas de Parcelamento

- [x] [Implementar uma tabela para armazenar as taxas de parcelamento **(InstallmentFees)**](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/db/migrate/20250227224235_create_installment_fees.rb) 

## 4. Recebíveis

- [x] [Implementar uma tabela para armazenar os recebiveis **(Receivables)**](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/db/migrate/20250227224750_create_receivables.rb)
  - [x] [Implementar método para calcular valor de repasse da parcela](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivable.rb#L30)
  - [x] [Implementar método para calcular valor de retenção da parcela](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivable.rb#L20)

Cada parcela gerada deverá ter as seguintes informações:
- [x] **schedule_date** Data de agendamento da parcela, que será a data da transação somada ao número de meses correspondente ao número da parcela
- [x] **liquidation_date** Data de pagamento, inicialmente nula e preenchida durante o processo de liquidação
- [x] **status** Status inicialmente "pendente", alterado para "liquidado" após a liquidação
- [x] **amount_to_settle** Valor a ser liquidado
- [x] **amount_settled** Inicialmente 0, será preenchido após a liquidação

## 5. Liquidação de Recebíveis via Cron

- [x] Implementar uma funcionalidade acionada por um [cron job](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/config/initializers/sidekiq_cron.rb) que [liquida os recebíveis, com base na data de agendamento](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/receivables/settle_all_today.rb)
  - [x] Se a data de agendamento for igual à data atual e o status da parcela for "pendente", a parcela será marcada como "liquidado"
  - [x] A `liquidation_date` será preenchida com a data atual
  - [x] O `amount_settled` será igual ao `amount_to_settle`

## 6. Listagem das Transações

- [x] [Implementar um endpoint para listar transações](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/controllers/payment_transactions_controller.rb#L2) com os seguintes filtros:
  - [x] [Filtro por intervalo de datas](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transactions/get.rb#L50) (se não informado, considerar os últimos 30 dias)
  - [x] [Paginação dos resultados](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/models/payment_transactions/get.rb#L61)

## 7. Listagem de Recebíveis

- [x] [Implementar um endpoint para listar todos os recebíveis](https://github.com/luiz-ouroboros/payment_api/blob/78eba055257b794a298bbbdf1500977ca863e388/app/controllers/receivables_controller.rb#L2), com possibilidade de filtro por transações aprovadas

## Tecnologias e Ferramentas Requeridas

- [x] Ruby on Rails: Framework principal para a construção da API
- [x] Sidekiq: Para processamento assíncrono da liquidação de recebíveis
- [x] RSpec: Para testes automatizados
- [x] Banco de Dados (PostgreSQL/MySQL): Para armazenar as tabelas de transações, taxas e recebíveis
- [x] Docker: Para facilitar a execução e a entrega da aplicação via containers

## Instruções para o Candidato

- [x] O código deve ser entregue em um repositório Git público
- [x] Todos os testes devem ser escritos utilizando RSpec
- [x] A aplicação deve estar configurada para rodar com Sidekiq para processamento assíncrono de recebíveis
- [ ] O candidato deve garantir que todos os requisitos sejam atendidos e que a API funcione conforme o esperado
- [ ] O código deve ser bem estruturado e legível
- [x] O código deve ter boa cobertura de testes (99.22% de cobertura de código)
