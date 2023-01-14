## Módulo de Network

### *vpc.tf* ####
Aqui é a criação da rede do nosso “datacenter” onde tudo vai ficar armazenado. 
Estaremos colocando uma tag em uma variavel, usando a função format que vai anexar ao final da string. 
    Por exemplo, se o nome do cluster for **“eks-demo”**, a VPC vai se chamar **“eks-demo-vpc”**, assim conseguimos manter um padrão de nomenclatura ao longo do projeto.
---
### *public.tf*
Este é o código da nossa subnet pública…

Estamos criando duas subnets, uma em cada **AZ (datacenter físico diferente na mesma região)**
Estamos usando a opção **map_public_ip_on_launch** que vai habilitar o uso de IP público em cada instância nessa subnet
Veja as tags **“kubernetes.io/cluster”…** Isso é obrigatório no cluster EKS. 
    É com base nessa tag que o cluster EKS sabe que pode usar a subnet.
Depois temos a associação da subnet em uma route table, isto é, as máquinas nessa subnet terão de respeitar as rotas do objeto **eks_public_rt**

---
### *private.tf*

Aqui é basicamente a mesma coisa do exemplo da **public.tf**, exceto pelo fato de que vamos adicionar as duas subnets privada na route table **eks_nat_rt.**
Ah, outro ponto é que não existe a opção **map_public_ip_on_launch**, ou seja, as máquinas nessa subnet não terão IP público.

---
### *internet-gateway.tf* ###
Estamos criando um **Internet Gateway** e atrelando ele na **route table eks_public_rt**. 
Isso significa que as instâncias na subnet pública poderão se comunicar **(incoming e outgoing)** com o mundo a fora passando pelo **Internet Gateway.**

---
### *nat-gateway.tf*
Aqui há algumas mudanças…

Alocamos um Elastic IP (um IP externo fixo que nunca muda)
Criamos um NAT Gateway na subnet pública
Criamos uma route table eks_nat_gw que direciona o tráfego externo para o NAT Gateway
Isso quer dizer que as VMs dentro da subnet privada poderão se comunicar com o mundo afora pelo NAT Gateway, que vai fazer NAT pro Elastic IP que alocamos, porém, não receberá tráfego interno.

Essa é a grande diferença entre o **Internet Gateway** e o **NAT Gateway.** O **Internet Gateway** envia e recebe (rede pública), o NAT Gateway só envia (rede privada).

---
### *output.tf*
Essa é a parte fundamental de usar programação com módulos. 
É baseado nesse arquivo que vamos coletar as saídas do módulos para usar no EKS.

Ou seja, vamos chamar o módulo de network, ele vai retornar qual é a VPC e as subnets privadas criadas, que são as informações que precisamos para instanciar o cluster EKS.


## Módulo do Master

---
### *iam.tf*
Para ter permissão de criar as EC2, fazer auto scaling e tals, o EKS precisa de uma role que permita fazer isso. 
Neste caso, estamos criando uma role que referencia o serviço do EKS.

Depois adicionamos as permissões AmazonEKSClusterPolicy e AmazonEKSServicePolicy na role.

---
### *security-group.tf*
Esse security group vai permitir a conexão HTTPS externa.

---
### *eks-master*
Aqui é onde criamos o cluster EKS de fato…

Note que estamos atrelando a role que criamos acima nesse cluster
Estamos também distribuindo em duas subnets privadas em diferentes availability zones
Lembram que na subnet pública nós colocamos uma tag chamada kubernetes.io? Pois é, quando criarmos um Ingress, ele vai procurar por uma subnet pública com aquela tag, por isso não precisamos referenciar aqui, mantemos somente na rede privada.

Criamos também uma dependência na role, porque na hora de remover com o Terraform, eu quero garantir que o cluster seja removido primeiro e depois a role. 
Imagina se eu removo a role e depois não tenho permissão para remover o cluster

---
### *output.tf*
Isso é bastante importante… Estou enviando o ID do cluster que foi criado para a saída do módulo. 
Isso porque o grupo de workers que vamos criar precisa estar atrelado a um cluster, logo, precisamos do ID dele!

## Módulo do Node

---
### *node-group.tf*
Note o seguinte:

Estou atrelando esse node group no cluster referenciado pelo parâmetro **cluster_name**
Também estou distribuindo em duas subnets privadas
Estou passando alguns parâmetros de escala horizontal, por exemplo… **“quero no mínimo 3 nodes, sendo que o ideal seria 5 e o máximo será 20”.** 
Assim o EKS sabe até onde ele pode escalar para não estourar o budget


## Execução

Aqui é onde toda a mágica acontece…

No primeiro módulo estamos informando o cluster_name e a region que queremos utilizar (lembra que essas são as variáveis necessárias pro módulo funcionar declaradas no variables.tf)
Segundamente, criamos o cluster EKS informando os IDs das redes privadas que foram criadas pelo módulo acima… Isso cria uma interdependência entre eles e garante que o módulo master depende do módulo network
Por último, criamos o node group apontando para as mesmas subnets privadas do módulo network e também usando o ID do cluster da saída do módulo master. Isto é, o módulo node depende dos outros módulos
