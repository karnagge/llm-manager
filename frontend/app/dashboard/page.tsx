import { Metadata } from "next";
import { DashboardHeader } from "@/components/dashboard/header";
import { DashboardShell } from "@/components/dashboard/shell";
import { UsageMetrics } from "@/components/dashboard/usage-metrics";
import { CostAnalysis } from "@/components/dashboard/cost-analysis";
import { RecentActivity } from "@/components/dashboard/recent-activity";

export const metadata: Metadata = {
  title: "Dashboard | LLM Manager",
  description: "Visão geral do uso e custos dos LLMs",
};

export default async function DashboardPage() {
  return (
    <DashboardShell>
      <DashboardHeader
        heading="Dashboard"
        text="Gerencie e monitore o uso dos LLMs."
      />
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <UsageMetrics />
      </div>
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <CostAnalysis className="col-span-4" />
        <RecentActivity className="col-span-3" />
      </div>
    </DashboardShell>
  );
}
