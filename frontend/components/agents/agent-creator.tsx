import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import { Form } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/components/ui/use-toast";
import { api } from "@/lib/api";

const agentSchema = z.object({
  name: z.string().min(3).max(50),
  description: z.string().min(10).max(500),
  domain: z.string().min(3),
  systemPrompt: z.string().min(10),
  tools: z.array(z.string()),
});

type AgentFormValues = z.infer<typeof agentSchema>;

export function AgentCreator() {
  const { toast } = useToast();
  const [isLoading, setIsLoading] = useState(false);

  const form = useForm<AgentFormValues>({
    resolver: zodResolver(agentSchema),
    defaultValues: {
      tools: [],
    },
  });

  async function onSubmit(data: AgentFormValues) {
    setIsLoading(true);
    try {
      await api.post("/api/v1/agents", data);
      toast({
        title: "Agente criado com sucesso!",
        description: "Seu novo agente está pronto para uso.",
      });
      form.reset();
    } catch (error) {
      toast({
        title: "Erro ao criar agente",
        description: "Verifique os dados e tente novamente.",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <div className="space-y-4">
          <Input
            label="Nome do Agente"
            {...form.register("name")}
            placeholder="Ex: Assistente de Análise de Dados"
          />
          
          <Textarea
            label="Descrição"
            {...form.register("description")}
            placeholder="Descreva o propósito e capacidades do agente..."
          />
          
          <Input
            label="Domínio"
            {...form.register("domain")}
            placeholder="Ex: data_analysis"
          />
          
          <Textarea
            label="Prompt do Sistema"
            {...form.register("systemPrompt")}
            placeholder="Defina o comportamento base do agente..."
          />
          
          {/* Seletor de Ferramentas */}
          <div className="space-y-2">
            <label className="text-sm font-medium">Ferramentas</label>
            {/* Adicione um componente de seleção múltipla aqui */}
          </div>
        </div>

        <Button type="submit" disabled={isLoading}>
          {isLoading ? "Criando..." : "Criar Agente"}
        </Button>
      </form>
    </Form>
  );
}
