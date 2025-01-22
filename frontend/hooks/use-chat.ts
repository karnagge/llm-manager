import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";

interface Message {
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
}

interface ChatResponse {
  response: string;
  metadata?: Record<string, any>;
}

export function useChat(agentId: string) {
  const queryClient = useQueryClient();
  const [messages, setMessages] = useState<Message[]>([]);

  // Carregar histórico de mensagens
  const { data: chatHistory } = useQuery({
    queryKey: ["chat-history", agentId],
    queryFn: async () => {
      const response = await api.get(`/api/v1/agents/${agentId}/chat-history`);
      setMessages(response.data);
      return response.data;
    },
  });

  // Mutation para enviar mensagem
  const { mutate: sendMessage, isPending: isLoading } = useMutation({
    mutationFn: async (content: string) => {
      // Adicionar mensagem do usuário imediatamente
      const userMessage: Message = {
        role: "user",
        content,
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, userMessage]);

      // Enviar para o backend
      const response = await api.post<ChatResponse>(
        `/api/v1/agents/${agentId}/chat`,
        { message: content }
      );

      // Adicionar resposta do assistente
      const assistantMessage: Message = {
        role: "assistant",
        content: response.data.response,
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, assistantMessage]);

      return response.data;
    },
    onSuccess: () => {
      // Invalidar cache do histórico
      queryClient.invalidateQueries({
        queryKey: ["chat-history", agentId],
      });
    },
  });

  return {
    messages,
    sendMessage,
    isLoading,
  };
}
