import { useState } from "react";
import { useChat } from "@/hooks/use-chat";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card } from "@/components/ui/card";
import { Avatar } from "@/components/ui/avatar";
import { useAgentContext } from "@/hooks/use-agent-context";

interface Message {
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
}

export function AgentChat() {
  const [input, setInput] = useState("");
  const { agent } = useAgentContext();
  const { messages, sendMessage, isLoading } = useChat(agent.id);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim()) return;

    await sendMessage(input);
    setInput("");
  };

  return (
    <div className="flex flex-col h-[600px] max-w-2xl mx-auto">
      <Card className="flex-1 p-4">
        <ScrollArea className="h-full pr-4">
          <div className="space-y-4">
            {messages.map((message, i) => (
              <div
                key={i}
                className={`flex gap-3 ${
                  message.role === "assistant" ? "flex-row" : "flex-row-reverse"
                }`}
              >
                <Avatar
                  className="h-8 w-8"
                  src={
                    message.role === "assistant"
                      ? agent.avatar
                      : "/avatars/user.png"
                  }
                />
                <div
                  className={`rounded-lg p-3 max-w-[80%] ${
                    message.role === "assistant"
                      ? "bg-secondary"
                      : "bg-primary text-primary-foreground"
                  }`}
                >
                  <p className="text-sm">{message.content}</p>
                  <span className="text-xs opacity-50 mt-1 block">
                    {new Date(message.timestamp).toLocaleTimeString()}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </ScrollArea>
      </Card>

      <form onSubmit={handleSubmit} className="mt-4 flex gap-2">
        <Input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Digite sua mensagem..."
          disabled={isLoading}
          className="flex-1"
        />
        <Button type="submit" disabled={isLoading}>
          {isLoading ? "Enviando..." : "Enviar"}
        </Button>
      </form>
    </div>
  );
}
