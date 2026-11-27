# Relatório de Validação — Mensal 4

## Grupo 22

- João Victor da Silva Siqueira
- Carlos de Mello Feliponi
- Lucas Eduardo Schneider Wiggers

## 1. Objetivo

Validar o provisionamento automatizado da infraestrutura,
a configuração dos servidores, a implantação da aplicação
To-Do e os procedimentos de manutenção e recuperação.

## 2. Evidências das pipelines

| Execução | Resultado | Registro |
|---|---|---|
| Infrastructure CI #5 | Provisionamento inicial | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45858056609/job/140041754963) |
| Infrastructure CI #6 | Configuração pelo Ansible | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45868637949) |
| Infrastructure CI #12 | Alteração da instância | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45877389566/job/140107994649) |
| Infrastructure CI #18 | Atualização da aplicação pelo Ansible | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45925526696) |
| Infrastructure CI #19 | Validação da idempotência | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45926409781) |
| Application CI #6 | Validação e publicação das imagens | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45925181112) |
| Application CI #5 | Rollback | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45891201167) |
| Application CI #3 | Deploy | [Logs](https://github.com/siqueiraj/mensal4-todo-app/actions/runs/45889526832) |

## 3. Cenário 1 — Provisionamento inicial

Resultado do Terraform:

    Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Foram provisionadas duas instâncias EC2, uma VPC,
sub-redes pública e privada, grupos de segurança,
rotas e armazenamento EBS para o MongoDB.

A execução Infrastructure CI #5 apresentou uma falha
posterior de autenticação SSH durante o Ansible.
A configuração foi concluída na execução #6.

## 4. Cenário 2 — Alteração e manutenção

A instância da aplicação foi alterada de t3.small
para t3.medium sem necessidade de recriação.

Resultado do Terraform:

    instance_type = "t3.small" -> "t3.medium"
    Plan: 0 to add, 1 to change, 0 to destroy.
    Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

O identificador da instância foi preservado.

A execução #12 apresentou falha geral após a alteração,
mas o Terraform concluiu a operação com sucesso.

A manutenção da aplicação por imagens versionadas
foi validada na execução Infrastructure CI #18.

## 5. Cenário 3 — Idempotência

A infraestrutura foi executada novamente utilizando
os mesmos parâmetros.

Resultado do Terraform:

    No changes. Your infrastructure matches the configuration.

Resultado do Ansible:

    app: ok=23 changed=0 unreachable=0 failed=0
    db:  ok=22 changed=0 unreachable=0 failed=0

Nenhuma alteração desnecessária foi realizada.

## 6. Inventário da infraestrutura

| Recurso | Identificação |
|---|---|
| EC2 aplicação | i-092927054d39db017 |
| EC2 banco de dados | i-026625b86ea4cd6bf |
| VPC | vpc-0db99077716473299 |
| Volume MongoDB | vol-0257bf88dcbf839c3 |
| IP privado aplicação | 10.0.1.51 |
| IP privado banco | 10.0.2.215 |
| IP público aplicação durante os testes | 44.199.200.74 |
| Região | us-east-1 |

O endereço público poderá mudar após um novo
provisionamento da infraestrutura.

## 7. Segurança e conectividade

O MongoDB foi implantado em uma instância exclusiva,
localizada na sub-rede privada e sem IP público.

Os testes externos apresentaram os seguintes resultados:

    Porta 5000: INACESSIVEL
    Porta 27017: INACESSIVEL
    Porta 8080: INACESSIVEL

A comunicação interna entre a aplicação e o banco
foi confirmada pelo funcionamento da API.

Resultado do health check:

    {"status":"healthy","database":"connected"}

O acesso público utiliza HTTPS:

    HTTP/2 200

URL: https://todoapp-grupo22.duckdns.org

## 8. Persistência dos dados

Foram realizados testes de reinicialização da aplicação,
recriação do container MongoDB e atualização das imagens.

As tarefas existentes e seus respectivos estados
foram preservados durante os testes.

Resultado registrado:

    SUCESSO: Dados preservados apos reinicializacao

O MongoDB utiliza armazenamento persistente em um
volume EBS dedicado, montado em /mnt/mongodb.

## 9. Deploy e rollback

As imagens da aplicação foram publicadas no GitHub
Container Registry utilizando o SHA dos commits
como identificador de versão.

Versão implantada ao final dos testes:

    25dc7c404c202cabe0d9abf79fcae148106f4346

Versão utilizada no teste de rollback:

    1d4b0745e894c6dedac948fc848590b7f5131cac

Os containers permaneceram saudáveis e os dados
foram preservados durante as operações.

## 10. Backup e restauração

O backup diário foi configurado pelo Ansible
para execução automática às 03h UTC.

Agendamento:

    0 3 * * * /usr/local/bin/todo-backup.sh >> /var/log/todo-backup.log 2>&1

Registro da execução automática em 27/11/2026:

    2026-11-27T03:00:01.401+0000 writing todo-app.todos to archive on stdout
    2026-11-27T03:00:01.404+0000 done dumping todo-app.todos (2 documents)
    Backup concluido: /mnt/mongodb/backups/todo-app-2026-11-27_03-00-01.archive.gz

Arquivos gerados:

| Backup | Horário UTC | Tamanho |
|---|---|---|
| Manual | 01:46 | 403 bytes |
| Automático | 03:00 | 403 bytes |

Os arquivos possuem permissões restritas ao usuário root.

O backup manual foi restaurado em um container
MongoDB isolado, sem interferir no banco de produção.

Resultado: dois documentos restaurados e nenhuma falha.

Uma cópia do backup também foi exportada para
armazenamento local e teve sua integridade verificada.

## 11. Teste funcional em outro dispositivo

Data: 27/11/2026.

Foi realizado um teste manual pelo celular,
utilizando o endereço público HTTPS da aplicação.

Operações validadas pelo integrante responsável:

- Acesso à aplicação.
- Criação de tarefa.
- Listagem de tarefas.
- Marcação como concluída.
- Recarregamento da página.
- Reabertura da tarefa.
- Exclusão da tarefa.

Resultado informado pelo responsável: sucesso.

Este teste foi registrado por relato manual,
sem captura de tela.

## 12. Conclusão

Os testes realizados demonstraram o funcionamento
da infraestrutura automatizada, da aplicação,
das pipelines de implantação, da persistência
dos dados e dos procedimentos de recuperação.

As falhas intermediárias foram registradas,
sem comprometer o resultado final dos testes.

A apresentação prática dos cenários permanece
prevista para a data definida pelo professor.

Após a validação, a infraestrutura poderá ser
desprovisionada pelo Terraform para evitar
custos desnecessários, sendo recriada para
a apresentação.

Os registros das pipelines estão disponíveis
aos usuários autorizados no repositório.
