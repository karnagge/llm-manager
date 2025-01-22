import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";
import { TenantLayout } from "@/components/layout/tenant-layout";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "LLM Manager",
  description: "Sistema Gerenciador Multi-tenant de LLMs",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR" suppressHydrationWarning>
      <body className={inter.className}>
        <Providers>
          <TenantLayout>{children}</TenantLayout>
        </Providers>
      </body>
    </html>
  );
}
