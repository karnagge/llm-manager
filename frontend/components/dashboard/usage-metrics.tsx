import { Card } from "@/components/ui/card";
import { useQuery } from "@tanstack/react-query";
import { MetricCard } from "@/components/ui/metric-card";
import { api } from "@/lib/api";

export function UsageMetrics() {
  const { data: metrics, isLoading } = useQuery({
    queryKey: ["usage-metrics"],
    queryFn: () => api.get("/api/v1/analytics/usage-metrics"),
  });

  if (isLoading) {
    return <div>Carregando métricas...</div>;
  }

  return (
    <>
      <MetricCard
        title="Total de Tokens"
        value={metrics?.totalTokens}
        description="Últimos 30 dias"
        trend={{
          value: metrics?.tokensTrend,
          label: "vs. mês anterior",
        }}
      />
      <MetricCard
        title="Custo Total"
        value={metrics?.totalCost}
        isCurrency
        description="Últimos 30 dias"
        trend={{
          value: metrics?.costTrend,
          label: "vs. mês anterior",
        }}
      />
      <MetricCard
        title="Agentes Ativos"
        value={metrics?.activeAgents}
        description="Neste momento"
      />
      <MetricCard
        title="Requisições/min"
        value={metrics?.requestsPerMinute}
        description="Média última hora"
        trend={{
          value: metrics?.requestsTrend,
          label: "vs. hora anterior",
        }}
      />
    </>
  );
}
