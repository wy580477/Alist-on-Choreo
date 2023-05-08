## 鸣谢

- [alist-org/alist](https://github.com/alist-org/alist)

## 概述

本项目用于在 Choreo 免费服务上部署 Alist。需要在 Cloudflare 上有一个托管的域名才可使用。

## 注意

 **请勿滥用，账号封禁风险自负**

## 变量

对部署时设定的变量做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `ArgoJSON` | `` | 必填，Cloudflared 隧道 JSON 文件内容 |
| `DATABASE_URL` | `` | 必填，数据库连接 URL |
| `SITE_URL` | `` | 网站URL，比如 https://example.com ，这个地址会在 Alist 程序中的某些地方使用。 |

更多变量及说明请参考：

https://github.com/alist-org/alist/blob/main/internal/conf/config.go

https://alist.nn.ci/zh/config/configuration.html

## 数据持久化

需要连接 MySQL 或是 PostgreSQL 数据库。

<details>
<summary><b> bit.to 免费 PostgreSQL 数据库</b></summary>

1. 前往 https://bit.io/ 注册账号，并新建一个数据库。
2. 点击数据库名称，进入数据库管理页面，点击左侧的 Connection，复制 "Postgres Connection" 下方字符串即为数据库连接 URL。
</details>

<details>
<summary><b>  planetscale.com 免费 MySQL 数据库</b></summary>

1. 前往 https://planetscale.com 注册账号，并新建一个数据库。
2. 点击数据库名称，进入数据库管理页面，点击左侧的 Connect，在 "connect with" 下拉菜单中选择 Symfony。
3. 下方 "mysql://" 开头字符串即为数据库连接 URL。密码只会显示一次，如果忘记保存了可以点击 "New password" 重新生成。
</details>

## 配置 Cloudflared 隧道

<details>
<summary><b>详情</b></summary>

 1. 前提在 Cloudflare 上有一个托管的域名，以example.com为例。以下为 Windows 系统命令举例。
 
 2. 下载  [Cloudflared](https://github.com/cloudflare/cloudflared/releases)
    
 3. 运行 cloudflared login，此步让你绑定域名。
    ```
    .\cloudflared-windows-amd64.exe login
    ``` 
 4. 运行 cloudflared tunnel create 隧道名，此步会生成隧道 JSON 配置文件。
    ```
    .\cloudflared-windows-amd64.exe tunnel create mytunnel
    ``` 
    
 5. 运行 cloudflared tunnel route dns 隧道名 argo.example.com, 生成cname记录，可以随意指定三级域名。
    ```
    .\cloudflared-windows-amd64.exe tunnel route dns mytunnel mytunnel.example.com
    ```  
    
 6. 部署时将 JSON 隧道配置文件内容填入 ArgoJSON 变量。
</details>

## 部署方式

**请勿使用本仓库直接部署**

 1. 点击本仓库右上角Fork，再点击Create Fork。  
 
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。   
 
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。  
 
 4. 登陆 console.choreo.dev ，然后新建一个 service ，并且授权 Choreo app 连接上面新建的仓库。
 
 ![image](https://user-images.githubusercontent.com/98247050/236745845-785557fd-9a06-45bf-ab4a-eda51820483f.png)
 
 5. 选择 Dockerfile，Dockerfile Path 填入 /Dockerfile , 点击 Create 。
 
 ![image](https://user-images.githubusercontent.com/98247050/236746621-02ed6d88-7b4a-486b-830f-b160a7f75095.png)
 
 6. 点击 Configs and Secrets ， 选择 Secret 和 Environment Variables， 点击 next 。
 
 ![image](https://user-images.githubusercontent.com/98247050/236747128-62aa160b-7884-4d0c-bf7b-6c8bf936889c.png)
 
 7. 按之前的说明设置环境变量，点击 create 。
 
 ![image](https://user-images.githubusercontent.com/98247050/236747635-0ae3ac28-bff5-4a55-85ec-fa5c13d776a2.png)
 
 8. 点击 Build and Deploy ，点击 Deploy Manually ，网页右侧会弹出提示，再点击 Deploy。
 
 9. 稍等一会儿后，再点击网页左侧 Observe，日志会显示 Alist 初始密码。如果没有显示，再等一会儿刷新网页。
