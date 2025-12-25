.PHONY: init plan apply destroy fmt validate clean

# Terraform 常用指令快捷方式

init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

# 格式化與驗證
fmt:
	terraform fmt -recursive

validate:
	terraform validate

# 顯示目前狀態
show:
	terraform show

output:
	terraform output

# 清理本地檔案（不影響雲端資源）
clean:
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
	rm -f *.tfplan

# 常用組合
check: fmt validate
	@echo "Format and validation passed!"

refresh:
	terraform refresh

# 匯入既有資源（範例）
# import-vpc:
# 	terraform import google_compute_network.vpc projects/$(PROJECT_ID)/global/networks/$(VPC_NAME)
