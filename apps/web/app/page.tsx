import { prisma } from "@repo/database";

export default async function IndexPage() {
  const users = await prisma.user.findMany();

  return (
    <div>
      <h1>Hello World , This is Rakesh3690 testing 123, deploy to docker </h1>
      <h2>Successfully deployed to Docker!</h2>
      <pre>{JSON.stringify(users, null, 2)}</pre>
    </div>
  );
}

export const dynamic = "force-dynamic";
