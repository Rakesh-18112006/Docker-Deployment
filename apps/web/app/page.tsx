import { prisma } from "@repo/database";

export default async function IndexPage() {
  const users = await prisma.user.findMany();

  return (
    <div>
      <h1>Hello World , This is Rakesh this is final testing</h1>
      <pre>{JSON.stringify(users, null, 2)}</pre>
    </div>
  );
}

export const dynamic = "force-dynamic";
