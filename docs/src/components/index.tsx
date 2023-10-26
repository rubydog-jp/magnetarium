import React from "react";
import clsx from "clsx";
import styles from "./styles.module.css";

type PR = {
  title: string;
  img: string;
  description: JSX.Element;
};

const PRs: PR[] = [
  {
    title: "1つ目",
    img: "pr-1.png",
    description: <>これは1つ目のアピールポイントです</>,
  },
  {
    title: "2つ目",
    img: "pr-2.png",
    description: <>これは2つ目のアピールポイントです</>,
  },
  {
    title: "3つ目",
    img: "pr-3.png",
    description: <>これは3つ目のアピールポイントです</>,
  },
];

function PRItem({ title, img, description }: PR) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">
        <img src={"img/" + img} width="40%" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function PRList(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {PRs.map((props, idx) => (
            <PRItem key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
