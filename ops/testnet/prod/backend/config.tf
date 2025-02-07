
locals {
  cartographer_env_vars = {
    CARTOGRAPHER_CONFIG = local.local_cartographer_config,
    DATABASE_URL        = "postgres://${var.postgres_user}:${var.postgres_password}@${module.cartographer_db.db_instance_endpoint}/connext",
    ENVIRONMENT         = var.environment,
    STAGE               = var.stage,
    DD_ENV              = "${var.environment}-${var.stage}",
    DD_LOGS_ENABLED     = true,
    DD_API_KEY          = var.dd_api_key
    DD_LAMBDA_HANDLER   = "packages/agents/cartographer/poller/dist/index.handler"
  }


  postgrest_env_vars = [
    { name = "PGRST_ADMIN_SERVER_PORT", value = "3001" },
    { name = "PGRST_DB_URI", value = "postgres://${var.postgres_user}:${var.postgres_password}@${module.cartographer_db.db_instance_endpoint}/connext" },
    { name = "PGRST_DB_SCHEMA", value = "public" },
    { name = "PGRST_DB_ANON_ROLE", value = "query" },
    { name = "ENVIRONMENT", value = var.environment },
    { name = "STAGE", value = var.stage }
  ]

  local_cartographer_config = jsonencode({
    logLevel = "debug"
    chains = {
      "1735356532" = {}
      "1735353714" = {}
      "9991"       = {}
      "1734439522" = {}
      "2053862260" = {}
      "1668247156" = {}
    }
    environment = var.stage
    healthUrls = {
      messages  = "https://betteruptime.com/api/v1/heartbeat/${var.carto_messages_heartbeat}"
      roots     = "https://betteruptime.com/api/v1/heartbeat/${var.carto_roots_heartbeat}"
      routers   = "https://betteruptime.com/api/v1/heartbeat/${var.carto_routers_heartbeat}"
      transfers = "https://betteruptime.com/api/v1/heartbeat/${var.carto_transfers_heartbeat}"
    }
  })
}
